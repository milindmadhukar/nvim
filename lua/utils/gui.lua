-- NOTE: Spawning new Neovide windows
--
-- Neovide has no "new window" command: one process is one window, and there is
-- no `:NeovideNewWindow` to ask it for another. A second window is a second
-- `neovide` process, and starting one from Lua has three requirements.
--
--  * The job must be **detached**. A normal job is killed when this Neovim
--    exits, so closing the window you spawned from would take the new window
--    with it.
--  * `$NVIM` must be cleared. Neovim exports the current instance's server
--    address to every job it starts, so anything inside the new window that
--    honours it -- `nvr`, `$EDITOR` wrappers run from a terminal buffer,
--    lazygit -- would open its files back in *this* window.
--  * Neovide's own `--fork` is the wrong tool. It exists so a shell prompt
--    returns immediately; detaching the job already does that, and `--fork`
--    on top of it just leaks an extra process between us and the window.
--
-- Two more, both of which produced a *windowless* Neovide spinning at 100% CPU
-- before they were handled:
--
--  * `stdin = "null"`. A job's stdin is a pipe by default, and Neovide hands
--    its own stdio down to the `nvim --embed` it starts. Given the job's pipe
--    it wires that child's stdin to the *write* end, the msgpack channel never
--    comes up, and the window is never mapped while the render loop spins.
--  * The environment is rebuilt rather than inherited. Neovide exports its own
--    runtime state (`NEOVIDE_IDLE`, `NEOVIDE_VSYNC`, ...) into the Neovim it
--    hosts, so every terminal inside this window carries them; a Neovide
--    started from there reads them back as *flags* and comes up with idling
--    and vsync disabled -- a window that renders flat out forever. `env` can
--    only set variables, so unsetting them means `clear_env` plus a copy of
--    the environment with the offenders left out.
--
-- Everything here works from a terminal Neovim too -- it launches the GUI.

local M = {}

local function executable()
  -- `vim.g.neovide_bin` is ours, not Neovide's: a hook for a wrapper script or
  -- an absolute path when `neovide` is not on $PATH.
  local exe = vim.g.neovide_bin or "neovide"
  if vim.fn.executable(exe) == 0 then
    vim.notify(("`%s` is not executable or not on $PATH"):format(exe), vim.log.levels.ERROR)
    return nil
  end
  return exe
end

---The environment for a new window: this one's, minus the variables that only
---describe *this* process.
---@return table<string, string>
function M.environment()
  local env = vim.fn.environ()

  -- $NVIM is this instance's server address, handed to every job Neovim
  -- starts. Left in place, an `nvr` or an $EDITOR wrapper run inside the new
  -- window would open its files back in this one.
  --
  -- Blanked rather than removed: Neovim re-adds $NVIM to a job's environment
  -- *after* `clear_env` is applied, so dropping the key just lets the real
  -- address back in. An explicit empty value survives, and every consumer
  -- treats empty as absent.
  env.NVIM = ""
  env.NVIM_LISTEN_ADDRESS = ""
  env.NVIM_LOG_FILE = nil

  -- Neovide's settings-as-environment, which a fresh Neovide would apply as
  -- command line flags instead of reading config.toml.
  for name in pairs(env) do
    if name:find "^NEOVIDE_" then
      env[name] = nil
    end
  end

  return env
end

---Launch a new, detached Neovide window.
---@param opts? table
---       cwd   string    directory to start in (default: this window's cwd)
---       files string[]  files to open (absolute paths, or relative to `cwd`)
---       line  integer   line to jump to; only meaningful with a single file
---       args  string[]  extra flags for neovide itself (--maximized, --grid, ...)
---@return integer|nil job id
function M.spawn(opts)
  opts = opts or {}

  local exe = executable()
  if not exe then
    return nil
  end

  local cwd = vim.fn.fnamemodify(vim.fn.expand(opts.cwd or assert(vim.uv.cwd())), ":p")
  if vim.fn.isdirectory(cwd) == 0 then
    vim.notify(("not a directory: %s"):format(cwd), vim.log.levels.ERROR)
    return nil
  end

  local cmd = { exe }
  vim.list_extend(cmd, opts.args or {})

  local files = opts.files or {}
  if opts.line and #files == 1 then
    -- `--` hands the rest to Neovim untouched, which is the only way to send
    -- it a `+<line>`. Neovide's own file list has no equivalent.
    vim.list_extend(cmd, { "--", "+" .. opts.line, files[1] })
  else
    -- Plain file arguments, so `--tabs` (Neovide's default) still applies.
    vim.list_extend(cmd, files)
  end

  local job = vim.fn.jobstart(cmd, {
    cwd = cwd,
    detach = true,
    stdin = "null",
    clear_env = true,
    env = M.environment(),
  })

  if job <= 0 then
    vim.notify(("failed to start %s (%d)"):format(exe, job), vim.log.levels.ERROR)
    return nil
  end

  vim.notify(("Neovide: " .. vim.fn.fnamemodify(cwd, ":~")), vim.log.levels.INFO)
  return job
end

---New window in this window's current directory.
function M.here()
  return M.spawn {}
end

---New window holding the current file, on the current line.
function M.file()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" or vim.bo.buftype ~= "" then
    return M.here()
  end
  -- cwd is left alone deliberately: project.nvim has already chdir'd this
  -- window to the project root, and the new window should land in the same
  -- place rather than in whatever directory the file happens to live in.
  return M.spawn {
    files = { vim.fn.fnamemodify(name, ":p") },
    line = vim.api.nvim_win_get_cursor(0)[1],
  }
end

---Root of the current project, as project.nvim sees it.
---Falls back to the cwd when the plugin is missing or the buffer is rootless.
function M.project()
  local ok, project = pcall(require, "project")
  local root = ok and project.get_project_root(0) or nil
  return M.spawn { cwd = root }
end

---Prompt for a directory (snacks renders the input, `dir` completion does
---the work) and open it.
function M.prompt()
  local ask = { prompt = "Neovide in directory: ", default = vim.fn.getcwd() .. "/", completion = "dir" }
  vim.ui.input(ask, function(dir)
    if dir and dir ~= "" then
      M.spawn { cwd = dir }
    end
  end)
end

---project.nvim's recent projects, newest first.
---`paths_only` matters: without it the fork hands back history entries
---(tables) rather than paths.
---@return string[]|nil
local function recent_projects()
  local ok, project = pcall(require, "project")
  if not ok then
    vim.notify("project.nvim is not loaded", vim.log.levels.WARN)
    return nil
  end

  local projects = vim.fn.reverse(project.get_recent_projects(true) or {})
  if vim.tbl_isempty(projects) then
    vim.notify("no recent projects yet", vim.log.levels.WARN)
    return nil
  end

  return projects
end

---Pick a recent project and open it in a new window. Telescope when it is
---available -- the list gets long enough that fuzzy matching beats scrolling
---it -- and vim.ui.select when it is not.
function M.recent()
  local projects = recent_projects()
  if not projects then
    return
  end

  local ok, pickers = pcall(require, "telescope.pickers")
  if not ok then
    vim.ui.select(projects, {
      prompt = "Neovide in project",
      format_item = function(path)
        return vim.fn.fnamemodify(path, ":~")
      end,
    }, function(choice)
      if choice then
        M.spawn { cwd = choice }
      end
    end)
    return
  end

  local finders = require "telescope.finders"
  local actions = require "telescope.actions"
  local state = require "telescope.actions.state"

  pickers
    .new(require("telescope.themes").get_dropdown {}, {
      prompt_title = "New Neovide window",
      finder = finders.new_table {
        results = projects,
        entry_maker = function(path)
          local display = vim.fn.fnamemodify(path, ":~")
          return { value = path, display = display, ordinal = display }
        end,
      },
      -- generic_sorter, not file_sorter: these are directories, and the fzf
      -- extension overrides this with its own matcher anyway.
      sorter = require("telescope.config").values.generic_sorter {},
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local entry = state.get_selected_entry()
          actions.close(prompt_bufnr)
          if entry then
            M.spawn { cwd = entry.value }
          end
        end)
        return true
      end,
    })
    :find()
end

---Telescope action: open whatever is selected in a new Neovide window.
---
---Bound to `<M-n>` in `defaults.mappings` (plugins/telescope.lua), so every
---picker that yields a path -- find_files, oldfiles, git_files, buffers,
---projects, live_grep -- doubles as a launcher, and `<CR>` still means "open
---it here".
---@param prompt_bufnr integer
function M.from_telescope(prompt_bufnr)
  local state = require "telescope.actions.state"
  local entry = state.get_selected_entry()
  local picker = state.get_current_picker(prompt_bufnr)
  -- Read the picker's cwd before closing it: file entries are relative to it.
  local cwd = picker and picker.cwd and tostring(picker.cwd) or nil

  require("telescope.actions").close(prompt_bufnr)

  local target = entry and (entry.path or entry.filename or entry.value)
  if type(target) ~= "string" or target == "" then
    vim.notify("that entry has no path to open", vim.log.levels.WARN)
    return
  end

  if not vim.startswith(target, "/") then
    target = vim.fs.joinpath(cwd or vim.fn.getcwd(), target)
  end

  -- The projects picker hands back directories, every other picker a file.
  if vim.fn.isdirectory(target) == 1 then
    return M.spawn { cwd = target }
  end

  return M.spawn { cwd = cwd, files = { target }, line = entry.lnum }
end

vim.api.nvim_create_user_command("NeovideNew", function(args)
  local target = args.args
  if target == "" then
    M.here()
  elseif vim.fn.isdirectory(vim.fn.expand(target)) == 1 then
    M.spawn { cwd = target }
  else
    local file = vim.fn.fnamemodify(vim.fn.expand(target), ":p")
    M.spawn { cwd = vim.fn.fnamemodify(file, ":h"), files = { file } }
  end
end, {
  nargs = "?",
  complete = "file",
  desc = "Open a new Neovide window (in a directory, or on a file)",
})

vim.api.nvim_create_user_command("NeovideNewFile", M.file, {
  desc = "Open the current file in a new Neovide window, on this line",
})

vim.api.nvim_create_user_command("NeovideNewProject", M.recent, {
  desc = "Open a recent project in a new Neovide window",
})

return M

-- NOTE: Window title
--
-- `titlestring` used to be the literal string "Neovim", so every window --
-- Neovide window, kitty tab, tmux pane -- was labelled identically and the
-- only way to find the right one was to click through them. This makes the
-- title say which project the window is in, then which file.
--
--     hipa-v2/core ▸ handler.go +
--     nvim ▸ lua/utils/title.lua
--
-- `titlestring` accepts statusline syntax, so the whole thing is one `%{}`
-- expression rather than a pile of autocmds: Neovim re-evaluates it on redraw,
-- which means it is already correct after a `:cd`, a project.nvim chdir, a
-- buffer switch or an edit, with nothing to keep in sync.
--
-- Neovide picks the title straight up from Neovim, and it is what Hyprland,
-- waybar, rofi and alt-tab show, so `title:` window rules can match on it too.

local M = {}

-- Directory names that identify nothing on their own. When the project root
-- ends in one of these the parent directory goes in front of it, turning
-- "core" into the "hipa-v2/core" that is actually recognisable.
local GENERIC = {
  ["."] = true,
  [".."] = true,
  app = true,
  backend = true,
  client = true,
  code = true,
  config = true,
  core = true,
  frontend = true,
  lib = true,
  packages = true,
  server = true,
  services = true,
  src = true,
  web = true,
  workspace = true,
}

-- getcwd() -> label. project.nvim chdirs globally (see plugins/project.lua),
-- so the cwd *is* the project root, and the label only has to be recomputed
-- when it changes -- not on every redraw.
local labels = {}

---Short, recognisable name for the directory the window is working in.
---@param cwd string
---@return string
local function project_label(cwd)
  if labels[cwd] then
    return labels[cwd]
  end

  local label
  local home = vim.uv.os_homedir()

  if cwd == home then
    label = "~"
  else
    local tail = vim.fn.fnamemodify(cwd, ":t")
    if tail == "" then
      -- Root, or a path ending in a separator.
      label = cwd
    elseif GENERIC[tail:lower()] then
      local parent = vim.fn.fnamemodify(cwd, ":h:t")
      label = parent ~= "" and (parent .. "/" .. tail) or tail
    else
      label = tail
    end
  end

  labels[cwd] = label
  return label
end

---What is being edited, relative to the project when it lives inside it.
---@param cwd string
---@return string|nil
local function buffer_label(cwd)
  local buftype = vim.bo.buftype

  if buftype == "terminal" then
    -- term://<cwd>//<pid>:<command>. Only the command is worth showing, and
    -- only its basename -- "$ zsh", not "$ /usr/bin/zsh --login".
    local name = vim.api.nvim_buf_get_name(0)
    local command = name:match "//%d+:(.*)$"
    return "$ " .. (command and vim.fn.fnamemodify(command:match "^%S+" or command, ":t") or "terminal")
  elseif buftype ~= "" then
    -- Help, quickfix, nvdash, prompt buffers: the project name alone is more
    -- use than "[Scratch]".
    return nil
  end

  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return nil
  end

  local path = vim.fn.fnamemodify(name, ":p")
  local relative = vim.fs.relpath(cwd, path)

  -- Files outside the project keep enough path to be identifiable, files
  -- inside it are shown relative to the root.
  return relative or vim.fn.fnamemodify(path, ":~")
end

---Rendered title. Called from `titlestring`; keep it cheap.
---@return string
function M.render()
  local cwd = vim.fn.getcwd()
  local title = project_label(cwd)

  local buffer = buffer_label(cwd)
  if buffer then
    title = title .. " ▸ " .. buffer
  end

  if vim.bo.modified and vim.bo.buftype == "" then
    title = title .. " +"
  end

  return title
end

vim.o.title = true
vim.o.titlestring = "%{v:lua.require'utils.title'.render()}"

return M

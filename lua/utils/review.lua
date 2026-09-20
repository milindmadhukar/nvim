-- NOTE: the review loop -- changed files, hunks, staging, diff panels.
--
-- This used to live inside paseo.nvim as `paseo.qf`, `paseo.pickers.changes`
-- and `paseo.review`. It moved here in 2026-09 because none of it is about
-- Paseo: it is ordinary telescope + quickfix + gitsigns plumbing that happens
-- to want a multi-repo view. The plugin kept the half that IS about Paseo --
-- asking an agent about the hunk under the cursor -- and now exposes the git
-- data layer these functions are built on.
--
-- The seam is `paseo.repos` and `paseo.git` (`:help paseo-git`):
--
--   repos.list()                  every repo in the unit of work
--   git.status(repo)              -> paseo.Change[]   changed files
--   git.hunks(repo, changes)      -> paseo.Hunk[]     hunks, -U0, qf-ready
--   git.diff_text(change, opts)   -> string[]         a diff, for a previewer
--   git.stage(hunk, cb)           stage one hunk, no buffer required
--
-- Requiring `paseo.*` at the top is safe even before the plugin has loaded:
-- lazy.nvim resolves a plugin's Lua modules through its own loader, so the
-- require both works and triggers the load.

local git = require "paseo.git"
local repos = require "paseo.repos"

local M = {}

-- The hunks behind the current quickfix list, indexed the same way.
-- `quickfixtextfunc` is handed indices, not entries, so it needs somewhere to
-- look them up -- and the stage action needs `file_deleted`, which a quickfix
-- entry has nowhere to carry.
---@type paseo.Hunk[]
local current = {}

---@param hunk paseo.Hunk
---@return string
local function counts(hunk)
  -- Not "new file": the span column already says `whole file` for these, and
  -- saying it twice on one row wastes the only column that carries a number.
  if hunk.kind == "new" then
    return "untracked"
  end
  return ("+%d -%d"):format(hunk.added, hunk.removed)
end

---The LAST line a hunk covers.
---
---`paseo.Hunk` carries a start and a count, not a span. For an add or a change
---the last line is `lnum + added - 1`. A PURE DELETION has `added == 0` and
---occupies exactly one line -- the line above the removed block, which is the
---line gitsigns acts on -- so the span collapses to `lnum` rather than going
---backwards, which `added - 1` would do.
---@param hunk paseo.Hunk
---@return integer
local function last_line(hunk)
  return hunk.lnum + math.max(hunk.added - 1, 0)
end

---`L34-L69`, or `L34` for a single line.
---@param hunk paseo.Hunk
---@return string
local function span(hunk)
  if hunk.kind == "new" then
    return "whole file"
  end
  local last = last_line(hunk)
  if last == hunk.lnum then
    return ("L%d"):format(hunk.lnum)
  end
  return ("L%d-L%d"):format(hunk.lnum, last)
end

-- Rendered through `quickfixtextfunc` so the entries keep real
-- `filename`/`lnum` values -- which is what makes `]q`, `:cc` and gitsigns all
-- work -- while still displaying as
--
--   clm_api  app/main.py      L34-L69    +7 -2
--   clm_api  app/main.py      L120       +1 -0
--   clm      src/otp.ts       L8-L11     +4 -4
--
-- Every row names its file, because a quickfix list has no headers: each line
-- is an entry, and a row that says only `L34-L69` is unreadable the moment the
-- list spans two files. The columns are padded so the ranges and counts line
-- up into something you can scan down.
---@param info table
---@return string[]
local function textfunc(info)
  local items = vim.fn.getqflist({ id = info.id, items = 1 }).items
  local lines = {}

  -- Measure across the window being drawn. The repo column appears only when
  -- there IS more than one repo, so a single-repo review does not pay for it.
  local repo_w, path_w, span_w, multi, first = 0, 0, 0, false, nil
  for i = info.start_idx, info.end_idx do
    local hunk = current[i]
    if hunk then
      first = first or hunk.repo.name
      multi = multi or hunk.repo.name ~= first
      repo_w = math.max(repo_w, #hunk.repo.name)
      -- Capped: one deeply nested path should not push every range off the
      -- right-hand side of the window.
      path_w = math.max(path_w, math.min(#hunk.path, 48))
      span_w = math.max(span_w, #span(hunk))
    end
  end

  for i = info.start_idx, info.end_idx do
    local hunk, item = current[i], items[i]
    if hunk and item then
      lines[#lines + 1] = table.concat {
        multi and (("%-" .. repo_w .. "s  "):format(hunk.repo.name)) or "",
        ("%-" .. path_w .. "s  "):format(hunk.path),
        ("%-" .. span_w .. "s  "):format(span(hunk)),
        counts(hunk),
      }
    elseif item then
      lines[#lines + 1] = item.text or ""
    end
  end

  return lines
end

---Every changed file across the unit of work. In a `ws` workspace that is all
---the member worktrees; in a plain repo it is just that repo.
---@return paseo.Change[]
function M.changed()
  local out = {}
  for _, repo in ipairs(repos.list()) do
    vim.list_extend(out, git.status(repo))
  end
  return out
end

---Replace the quickfix list with one entry per HUNK.
---
---One entry per hunk, not per file, because the unit of review is a hunk: `]q`
---has to land on something you can read and then stage, and a file entry puts
---you at line 1 of a 400-line file with no idea what changed.
---@param changes paseo.Change[]
---@param opts? { open?: boolean, title?: string }
---@return integer count
function M.quickfix(changes, opts)
  opts = opts or {}

  -- Group by repo so `git diff` runs once per repo rather than once per file.
  local by_repo, order = {}, {}
  for _, change in ipairs(changes) do
    local key = change.repo.worktree
    if not by_repo[key] then
      by_repo[key] = { repo = change.repo, changes = {} }
      order[#order + 1] = key
    end
    table.insert(by_repo[key].changes, change)
  end

  current = {}
  for _, key in ipairs(order) do
    local group = by_repo[key]
    vim.list_extend(current, git.hunks(group.repo, group.changes))
  end

  local items = {}
  for _, hunk in ipairs(current) do
    items[#items + 1] = {
      -- Absolute: the list outlives whatever cwd built it, and in a workspace
      -- the entries come from several different worktrees.
      filename = vim.fs.joinpath(hunk.repo.worktree, hunk.path),
      lnum = hunk.lnum,
      col = 1,
      -- `end_lnum` is how a quickfix entry says "this covers a RANGE", and
      -- setting it costs nothing: `:cc` and `]q` still jump to `lnum`. It is
      -- what makes the span real rather than just rendered -- Trouble
      -- (<leader>tq) and anything else reading the list gets it too.
      end_lnum = last_line(hunk),
      -- Carries the span as well, because `quickfixtextfunc` is NOT universal:
      -- Trouble renders from the item fields itself and never calls it. This
      -- is the row you see there, under Trouble's own filename heading.
      text = ("%s  %s"):format(span(hunk), counts(hunk)),
      type = hunk.kind == "delete" and "W" or "I",
    }
  end

  vim.fn.setqflist({}, " ", {
    title = opts.title or "hunks",
    items = items,
    quickfixtextfunc = textfunc,
  })

  if opts.open ~= false and #current > 0 then
    vim.cmd "botright copen"
    vim.cmd "wincmd p"
  end

  return #current
end

---Every hunk in the unit of work, as a quickfix list.
---@param opts? { open?: boolean }
---@return integer count
function M.hunks(opts)
  local count = M.quickfix(M.changed(), opts)
  if count == 0 then
    vim.notify("review: nothing changed", vim.log.levels.INFO)
  end
  return count
end

---Which entry to act on.
---
---`getqflist({ idx = 0 }).idx` is the CURRENT ENTRY -- the one last jumped to
---with `:cc` or `]q` -- and moving the cursor around the quickfix window does
---not change it. So while you are sitting in the list, walking down it with
---`j` and staging as you go, that index is stale and you would stage a hunk
---you are not looking at. In the quickfix window the cursor line IS the
---entry; everywhere else the current entry is the right answer.
---
---A location list window also reports `buftype == "quickfix"`, hence the
---`loclist` check: this module only ever populates the quickfix list.
---@return integer
local function target_index()
  if vim.bo.buftype == "quickfix" then
    local info = vim.fn.getwininfo(vim.fn.win_getid())[1]
    if info and info.loclist == 0 then
      return vim.fn.line "."
    end
  end
  return vim.fn.getqflist({ idx = 0 }).idx
end

---The hunk behind quickfix entry `idx`, or the one being acted on.
---@param idx? integer
---@return paseo.Hunk|nil
function M.hunk(idx)
  return current[idx or target_index()]
end

---Drop entry `idx` from the list and land on whatever takes its place.
---
---`current` has to be spliced in lockstep with the items: it is indexed
---parallel to the list, and `quickfixtextfunc` looks hunks up by index. Remove
---from one and not the other and every row below the gap renders the wrong
---hunk -- silently, and with plausible-looking output.
---@param idx integer
---@return boolean removed
function M.drop(idx)
  local items = vim.fn.getqflist()
  if not items[idx] then
    return false
  end

  table.remove(items, idx)
  table.remove(current, idx)

  -- "r" replaces the items of the CURRENT list rather than pushing a new one,
  -- so `:colder` still has whatever you had before this review. The textfunc
  -- is re-supplied because it is a property of the list, not of the items.
  vim.fn.setqflist({}, "r", {
    title = vim.fn.getqflist({ title = 1 }).title,
    items = items,
    quickfixtextfunc = textfunc,
  })

  if #items == 0 then
    vim.notify("review: everything staged", vim.log.levels.INFO)
    -- Close the list rather than leaving an empty window sitting there: this
    -- is the end of the loop, and an empty quickfix window is just clutter.
    pcall(vim.cmd.cclose)
    return true
  end

  local next_idx = math.min(idx, #items)
  if vim.bo.buftype == "quickfix" then
    -- Stay in the list. Jumping would yank focus into the source file, which
    -- is the opposite of what you want while working down the list.
    pcall(vim.api.nvim_win_set_cursor, 0, { next_idx, 0 })
  else
    -- Staging from the source buffer: land on the next hunk, which is the
    -- review loop -- read, stage, next.
    pcall(vim.cmd, ("cc %d"):format(next_idx))
  end
  return true
end

---Stage the hunk the quickfix list is on, then drop it from the list.
---
---DROPPING IS SAFE, and not obviously so. The list's line numbers come from
---`git diff HEAD`, which compares the working tree against HEAD -- and staging
---moves changes into the INDEX without touching the working tree. So no other
---hunk's `lnum` moves when you stage one, and removing just the staged entry
---leaves the rest of the list correct. Anything that edits the working tree
---does invalidate it; rebuild with <leader>aq after that.
---
---Goes through `git.stage`, not `gitsigns.stage_hunk`, for two reasons that
---both showed up in testing. Staging from a list means opening the file first,
---and gitsigns attaches ASYNCHRONOUSLY -- called straight after `:edit` it
---finds no cache and returns silently, which lost four hunks in six. And a
---whole-file deletion has no file to open at all, so nothing ever attaches.
---@param opts? { remove?: boolean, advance?: boolean }
function M.stage(opts)
  opts = opts or {}
  local idx = target_index()
  local hunk = current[idx]
  if not hunk then
    vim.notify("review: no hunk under the cursor", vim.log.levels.WARN)
    return
  end

  git.stage(hunk, function(err)
    if err then
      vim.notify("review: " .. err, vim.log.levels.ERROR)
      return
    end
    vim.notify(("staged %s:%d"):format(hunk.path, hunk.lnum), vim.log.levels.INFO)

    if opts.remove == false then
      if opts.advance ~= false then
        pcall(vim.cmd.cnext)
      end
      return
    end
    M.drop(idx)
  end)
end

-- --------------------------------------------------------------- picker

---Two-character status, rendered so the eye can sort it. Index first, worktree
---second -- the order git prints, so `MM` means "staged edits and further
---unstaged edits", which is the case worth noticing.
---@param change paseo.Change
---@return string
local function code(change)
  if change.untracked then
    return "??"
  end
  local function glyph(c)
    return (c == nil or c == "." or c == "") and " " or c
  end
  return glyph(change.index) .. glyph(change.worktree)
end

---@param multi boolean  Whether to show the repo column.
---@param width integer
local function entry_maker(multi, width)
  return function(change)
    local repo = multi and (("%-" .. width .. "s "):format(change.repo.name)) or ""
    local rename = change.orig_path and (" ← " .. change.orig_path) or ""
    return {
      value = change,
      display = ("%s %s%s%s"):format(code(change), repo, change.path, rename),
      -- The repo name is in the ordinal on purpose: typing `clm_api` filters
      -- to that member, which is the fastest way to review one repo at a time.
      ordinal = ("%s %s %s"):format(change.repo.name, change.path, change.orig_path or ""),
      path = vim.fs.joinpath(change.repo.worktree, change.path),
    }
  end
end

---The previewer: a DIFF, not the file.
---
---`git diff HEAD` rather than plain `git diff`, so staged and unstaged changes
---appear together -- what you are reviewing is the whole change, not the half
---you have not staged yet. `git.diff_text` also handles the untracked case,
---which goes through `--no-index` and exits 1 by design.
local function previewer()
  local ok, previewers = pcall(require, "telescope.previewers")
  if not ok then
    return nil
  end

  return previewers.new_buffer_previewer {
    title = "Diff vs HEAD",
    define_preview = function(self, entry)
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, git.diff_text(entry.value, { context = 3 }))
      vim.bo[self.state.bufnr].filetype = "diff"
    end,
  }
end

---The changed-files picker: the entry point to the review loop.
---
---Worth having over `:Telescope git_status` for two reasons: it spans every
---repo in the unit of work rather than one, and `<C-q>` expands into HUNKS
---rather than files.
---
---  <CR>   open the file on its FIRST HUNK
---  <C-q>  selected files (or the one under the cursor) -> hunk quickfix list
---  <C-a>  everything -> hunk quickfix list
---@param opts? table  Telescope options.
function M.changes(opts)
  opts = opts or {}

  local ok, pickers = pcall(require, "telescope.pickers")
  if not ok then
    vim.notify("review: telescope is not available", vim.log.levels.ERROR)
    return
  end

  local finders = require "telescope.finders"
  local actions = require "telescope.actions"
  local state = require "telescope.actions.state"
  local conf = require("telescope.config").values

  local changes = M.changed()
  if #changes == 0 then
    vim.notify("review: nothing changed", vim.log.levels.INFO)
    return
  end

  local first, multi, width = changes[1].repo.name, false, 0
  for _, change in ipairs(changes) do
    multi = multi or change.repo.name ~= first
    width = math.max(width, #change.repo.name)
  end

  ---Selected entries, or the one under the cursor when nothing is marked.
  ---@return paseo.Change[]
  local function selection(bufnr)
    local picker = state.get_current_picker(bufnr)
    local marked = picker and picker:get_multi_selection() or {}
    if #marked > 0 then
      return vim.tbl_map(function(entry)
        return entry.value
      end, marked)
    end
    local entry = state.get_selected_entry()
    return entry and { entry.value } or {}
  end

  pickers
    .new(opts, {
      prompt_title = multi and "Changes (workspace)" or "Changes",
      finder = finders.new_table {
        results = changes,
        entry_maker = entry_maker(multi, width),
      },
      -- generic_sorter, not file_sorter: the ordinal leads with a repo name,
      -- and the path sorter would score that as a directory component.
      sorter = conf.generic_sorter(opts),
      previewer = previewer(),
      attach_mappings = function(bufnr, map)
        -- <CR> opens the file on its FIRST HUNK rather than line 1. Landing on
        -- line 1 of a 400-line file tells you nothing about what changed.
        actions.select_default:replace(function()
          local entry = state.get_selected_entry()
          actions.close(bufnr)
          if not entry then
            return
          end
          local hunks = git.hunks(entry.value.repo, { entry.value })
          vim.cmd.edit(vim.fn.fnameescape(entry.path))
          if hunks[1] then
            pcall(vim.api.nvim_win_set_cursor, 0, { hunks[1].lnum, 0 })
          end
        end)

        map({ "i", "n" }, "<C-q>", function()
          local picked = selection(bufnr)
          actions.close(bufnr)
          M.quickfix(picked, { title = "hunks" })
        end)
        map({ "i", "n" }, "<C-a>", function()
          actions.close(bufnr)
          M.hunks()
        end)
        return true
      end,
    })
    :find()
end

-- ----------------------------------------------------------- diff panel

---True when a tab holds nothing but one empty, unmodified buffer -- i.e. it is
---the staging tab we made and gitsigns then opened its panel elsewhere.
---@param tab integer
---@return boolean
local function is_scratch(tab)
  local wins = vim.api.nvim_tabpage_list_wins(tab)
  if #wins ~= 1 then
    return false
  end
  local buf = vim.api.nvim_win_get_buf(wins[1])
  return vim.api.nvim_buf_get_name(buf) == "" and not vim.bo[buf].modified
end

---Tab-scoped chdir is load-bearing and project.nvim fights it: `silent_chdir`
---with `scope_chdir = "global"` re-chdirs on buffer switches, which would
---repoint every panel at whichever repo was touched last. Rather than
---reconfigure a plugin we want global, re-assert the tcd on TabEnter.
---@param worktree string
local function pin_cwd(worktree)
  vim.cmd.tcd(vim.fn.fnameescape(worktree))

  local tab = vim.api.nvim_get_current_tabpage()
  vim.api.nvim_create_autocmd("TabEnter", {
    group = vim.api.nvim_create_augroup("user_review_panel_" .. tab, { clear = true }),
    callback = function()
      if not vim.api.nvim_tabpage_is_valid(tab) then
        return true
      end
      if vim.api.nvim_get_current_tabpage() == tab and vim.fn.getcwd() ~= worktree then
        vim.cmd.tcd(vim.fn.fnameescape(worktree))
      end
    end,
  })
end

---A `:Gitsigns diff` panel per repo, each in its own tab.
---
---`:Gitsigns diff` is per-tab and single-repo BY DESIGN: it resolves its repo
---from `fn.getcwd()` and names its buffer `gitsigns-diff://<gitdir>//<tab>`.
---So a workspace gets one tab per member repo, each `tcd`'d into that repo --
---the only arrangement in which the panel can show more than one at once.
---This is what `<leader>gd` cannot do; for a single repo the two are the same.
---
---SERIALISED, and not as a style choice: `gitsigns.diff()` runs its body
---asynchronously and reads `fn.getcwd()` INSIDE it, so firing one per repo in
---a loop means every panel resolves against whichever tab was current when its
---body finally ran -- the last one. Observed: two tabs, two `tcd`s, zero
---panels. Each panel now waits for the previous one's callback.
---@param opts? { unified?: boolean }
---@param callback? fun(opened: integer)
function M.panel(opts, callback)
  opts = opts or {}
  callback = callback or function() end

  local list = repos.list()
  if #list == 0 then
    vim.notify("review: not inside a git repository", vim.log.levels.WARN)
    return callback(0)
  end

  if not pcall(require, "gitsigns") then
    vim.notify("review: gitsigns is not available", vim.log.levels.ERROR)
    return callback(0)
  end

  local gs = require "gitsigns"
  local opened, index = 0, 0

  local function step()
    index = index + 1
    local repo = list[index]
    if not repo then
      if opened > 1 then
        vim.cmd.tabfirst()
      end
      if opened == 0 then
        vim.notify("review: no diff panel opened", vim.log.levels.WARN)
      end
      return callback(opened)
    end

    -- A staging tab, purely to own a cwd for the panel to resolve against.
    -- The panel opens in a tab of its own, so this one is discarded after.
    vim.cmd.tabnew()
    vim.cmd.tcd(vim.fn.fnameescape(repo.worktree))
    local staging = vim.api.nvim_get_current_tabpage()

    -- The Lua API rather than `:Gitsigns diff`, because only this form takes a
    -- callback -- and without the callback there is nothing to serialise on.
    gs.diff(nil, nil, { diff = opts.unified and "unified" or nil }, function(err)
      local panel = vim.api.nvim_get_current_tabpage()

      if err then
        vim.notify(("review: %s: %s"):format(repo.name, err), vim.log.levels.ERROR)
      else
        opened = opened + 1
        -- The panel inherits the staging tab's cwd, so re-pin it there; that
        -- is the tab that has to survive project.nvim's global chdir.
        if panel ~= staging then
          pin_cwd(repo.worktree)
        end
      end

      -- Drop the staging tab, but only if it is still the empty scratch we
      -- made -- never if the panel landed in it, and never if something else
      -- claimed it.
      if panel ~= staging and vim.api.nvim_tabpage_is_valid(staging) and is_scratch(staging) then
        pcall(vim.cmd, ("tabclose %d"):format(vim.api.nvim_tabpage_get_number(staging)))
      elseif err and panel == staging and is_scratch(staging) then
        pcall(vim.cmd, ("tabclose %d"):format(vim.api.nvim_tabpage_get_number(staging)))
      end

      vim.schedule(step)
    end)
  end

  step()
end

return M

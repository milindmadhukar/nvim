-- NOTE: paseo.nvim -- review and agents, without leaving Neovim
--
-- Loaded straight out of ~/Code/paseo.nvim rather than being cloned: `dev` in
-- core/lazy.lua points at ~/Code, and `patterns = { "milindmadhukar" }` already
-- matches this spec's owner, but `dev = true` is written out anyway so the
-- reason is visible at the spec. Same arrangement as plugins/floaterm.lua.
--
-- `pin = true` keeps :Lazy update/sync from checking out over the top of
-- in-progress work in that tree.
--
-- To switch to the published version later: drop `dev` and `pin`.

return {
  "milindmadhukar/paseo.nvim",
  dev = true,
  pin = true,

  dependencies = {
    "nvim-telescope/telescope.nvim",
    "lewis6991/gitsigns.nvim",
  },

  -- VeryLazy rather than `cmd = "Paseo"`. lazy.nvim has no checkhealth
  -- integration -- there is no `checkhealth` anywhere in its loader -- so an
  -- unloaded plugin is not on the runtimepath and a cold `:checkhealth paseo`
  -- answers "No healthcheck found", which reads like a broken install rather
  -- than a lazy one. Loading costs a table merge, one autocmd and one command.
  event = "VeryLazy",

  keys = {
    { "<leader>a", "", desc = "+Agent / Review" },

    -- The chat is the primary surface: the whole point is not to open the
    -- Paseo app.
    { "<leader>aa", "<cmd>Paseo chat<cr>", desc = "Chat" },
    { "<leader>ae", "<cmd>Paseo explain<cr>", desc = "Explain this hunk" },
    { "<leader>ak", "<cmd>Paseo ask<cr>", desc = "Ask about this hunk" },
    { "<leader>af", "<cmd>Paseo ask file<cr>", desc = "Ask about this file" },
    -- Visual mode sends the live selection. These have to pass `visual`
    -- explicitly; the reference builder reads getpos("v"), not the marks,
    -- because a <cmd> mapping fires while visual mode is still active.
    { "<leader>ae", "<cmd>Paseo explain visual<cr>", mode = "v", desc = "Explain this selection" },
    { "<leader>ak", "<cmd>Paseo ask visual<cr>", mode = "v", desc = "Ask about this selection" },
    { "<leader>aQ", "<cmd>Paseo qfask<cr>", desc = "Ask about everything in the quickfix list" },

    -- Review.
    --
    -- These are OURS now, not the plugin's. paseo.nvim dropped :Paseo
    -- changes/hunks/stage/review in 2026-09 -- none of it was about Paseo --
    -- and kept `paseo.repos` + `paseo.git` as the data layer utils/review.lua
    -- is built on. See `:help paseo-git`.
    --
    -- They stay on THIS spec's `keys` rather than moving to whichkey.lua so
    -- that pressing one loads paseo.nvim first; utils/review.lua requires
    -- `paseo.git` at its top.
    {
      "<leader>ac",
      function()
        require("utils.review").changes()
      end,
      desc = "Changed files (workspace)",
    },
    {
      "<leader>aq",
      function()
        require("utils.review").hunks()
      end,
      desc = "Hunks → quickfix",
    },
    {
      "<leader>as",
      function()
        require("utils.review").stage()
      end,
      desc = "Stage hunk under quickfix cursor",
    },
    -- <leader>gd is the single-repo `:Gitsigns diff`. These are the workspace
    -- version: one panel per member repo, one tab each.
    {
      "<leader>ar",
      function()
        require("utils.review").panel {}
      end,
      desc = "Diff panel (per repo)",
    },
    {
      "<leader>au",
      function()
        require("utils.review").panel { unified = true }
      end,
      desc = "Diff panel (unified)",
    },

    -- Workspaces and plumbing.
    { "<leader>aw", "<cmd>Paseo workspaces<cr>", desc = "Workspaces" },
    { "<leader>aW", "<cmd>Paseo wcreate<cr>", desc = "New workspace" },
    { "<leader>aS", "<cmd>Paseo sessions<cr>", desc = "Sessions in this workspace" },
    -- Session controls: the row under the composer in the Paseo app.
    { "<leader>ap", "<cmd>Paseo mode<cr>", desc = "Permission mode" },
    { "<leader>ah", "<cmd>Paseo thinking<cr>", desc = "Thinking level" },
    { "<leader>az", "<cmd>Paseo fast<cr>", desc = "Toggle fast mode" },
    { "<leader>am", "<cmd>Paseo switchmodel<cr>", desc = "Model (this session)" },
    { "<leader>aM", "<cmd>Paseo model<cr>", desc = "Model (new agents)" },
    { "<leader>a?", "<cmd>Paseo session<cr>", desc = "Session settings" },
    { "<leader>at", "<cmd>Paseo agent<cr>", desc = "Agents / sidecar status" },
    { "<leader>aR", "<cmd>Paseo repos<cr>", desc = "Repos in this unit of work" },
    { "<leader>aH", "<cmd>Paseo health<cr>", desc = "Health" },
  },

  -- The workspace picker's <C-r> ("review it here") no longer builds a list
  -- itself: it tcd's into the workspace, invalidates the repo cache, and fires
  -- this. What "review" means is ours to decide -- see `:help paseo-ref` and
  -- `:help paseo-git`.
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "PaseoReview",
      group = vim.api.nvim_create_augroup("user_paseo_review", { clear = true }),
      callback = function()
        require("utils.review").hunks()
      end,
      desc = "paseo: <C-r> in the workspace picker -> hunk quickfix list",
    })
  end,

  opts = {
    workspaces = {
      -- Switch THIS Neovim, rather than spawning a window per workspace.
      --
      -- Spawning was the plugin's own behaviour until 2026-09, when it moved
      -- out to this key and defaulted to "tab" -- a new tab page, `tcd`'d in.
      -- "tcd" goes one further and reuses the current tab, which is what
      -- <C-r> ("review it here") has always done, so <CR> and <C-r> now land
      -- you in the same place and differ only in what they then open.
      --
      -- The cost is real and is the reason the spawn existed: the buffers,
      -- LSP clients and jumplist of the workspace you just left stay in this
      -- tab, pointing into it. Use "tab" to pay one tab for keeping them
      -- apart; `utils.gui` is still one line away if the window comes back:
      --
      --   open = function(ws) require("utils.gui").spawn { cwd = ws.directory } end,
      open = "tcd",
    },

    ui = {
      float = {
        -- The same box floaterm opens (plugins/floaterm.lua: size = { h = 90,
        -- w = 92 }), so <C-\> and <leader>aa put a window in the same place
        -- and switching between them does not move the frame under you.
        --
        -- Same unit, same arithmetic, same centring, so these two numbers are
        -- the whole translation -- copy them from one config to the other.
        width = 92,
        height = 90,
      },
    },
  },
}

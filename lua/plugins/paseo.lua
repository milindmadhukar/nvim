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
    { "<leader>aQ", "<cmd>Paseo qfask<cr>", desc = "Ask about every hunk in the quickfix list" },

    -- Review.
    { "<leader>ac", "<cmd>Paseo changes<cr>", desc = "Changed files" },
    { "<leader>aq", "<cmd>Paseo hunks<cr>", desc = "Hunks → quickfix" },
    { "<leader>as", "<cmd>Paseo stage<cr>", desc = "Stage hunk under quickfix cursor" },
    { "<leader>ar", "<cmd>Paseo review<cr>", desc = "Diff panel (per repo)" },
    { "<leader>au", "<cmd>Paseo review unified<cr>", desc = "Diff panel (unified)" },

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

  opts = {
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

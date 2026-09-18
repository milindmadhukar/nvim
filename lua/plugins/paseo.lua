-- NOTE: paseo.nvim -- the review-and-agent layer
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

  -- Telescope is a hard dependency of the pickers rather than a soft one: the
  -- changed-files picker is the entry point to everything else here.
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "lewis6991/gitsigns.nvim",
  },

  -- VeryLazy rather than `cmd = "Paseo"`, which is what this started as.
  -- lazy.nvim has no checkhealth integration -- there is no `checkhealth` in
  -- its loader at all -- so a plugin that is not yet loaded is not on the
  -- runtimepath, and a cold `:checkhealth paseo` answers "No healthcheck found
  -- for \"paseo\" plugin", which reads like a broken install rather than a
  -- lazy one. Loading it costs a table merge, one autocmd and one user command;
  -- VeryLazy keeps all of that off the startup path anyway.
  event = "VeryLazy",

  -- <leader>a was the only free top-level letter. Only keys whose subcommands
  -- exist are bound -- an entry for something not built yet reads like a
  -- promise and errors like a bug.
  keys = {
    { "<leader>a", "", desc = "+Agent / Review" },
    { "<leader>aa", "<cmd>Paseo changes<cr>", desc = "Changed files" },
    { "<leader>ae", "<cmd>Paseo explain<cr>", desc = "Explain this hunk" },
    { "<leader>ae", "<cmd>Paseo explain visual<cr>", mode = "v", desc = "Explain this selection" },
    { "<leader>ak", "<cmd>Paseo ask<cr>", desc = "Ask about this hunk" },
    { "<leader>ak", "<cmd>Paseo ask visual<cr>", mode = "v", desc = "Ask about this selection" },
    { "<leader>af", "<cmd>Paseo explain file<cr>", desc = "Explain this file" },
    { "<leader>at", "<cmd>Paseo agent<cr>", desc = "Agents / sidecar status" },
    { "<leader>aw", "<cmd>Paseo workspaces<cr>", desc = "Workspaces" },
    { "<leader>aq", "<cmd>Paseo hunks<cr>", desc = "Hunks → quickfix" },
    { "<leader>ar", "<cmd>Paseo review<cr>", desc = "Diff panel (per repo)" },
    { "<leader>au", "<cmd>Paseo review unified<cr>", desc = "Diff panel (unified)" },
    { "<leader>as", "<cmd>Paseo stage<cr>", desc = "Stage hunk under quickfix cursor" },
    { "<leader>aR", "<cmd>Paseo repos<cr>", desc = "Repos in this unit of work" },
    { "<leader>aH", "<cmd>Paseo health<cr>", desc = "Health" },
  },

  opts = {},
}

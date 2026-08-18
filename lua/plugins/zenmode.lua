-- NOTE: Distraction-free writing
--
-- true-zen.nvim has had no commits since 2024-07.
return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
  },
  opts = {
    window = {
      backdrop = 0.95,
      width = 120,
      options = {
        number = false,
        relativenumber = false,
        signcolumn = "no",
      },
    },
    plugins = {
      options = { laststatus = 0, showcmd = false, ruler = false },
      gitsigns = { enabled = false },
    },
  },
}

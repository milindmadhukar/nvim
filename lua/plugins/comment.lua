-- NOTE: Commenting
--
-- Neovim 0.10+ has built-in commenting (`gc`, `gcc`, `gbc`), so Comment.nvim
-- is no longer needed. ts-comments.nvim only teaches the builtin about
-- treesitter-aware commentstrings (JSX, Vue, embedded languages), replacing
-- nvim-ts-context-commentstring.
return {
  "folke/ts-comments.nvim",
  event = "VeryLazy",
  opts = {},
  init = function()
    -- Keep the familiar <leader>/ binding, now driven by the builtin operator.
    vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle Comment" })
    vim.keymap.set("x", "<leader>/", "gc", { remap = true, desc = "Toggle Comment" })
  end,
}

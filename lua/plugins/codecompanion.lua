local M = {
  "olimorris/codecompanion.nvim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}


function M.config()
  require("codecompanion").setup({
    opts = {
      log_level = "DEBUG", -- or "TRACE"
    }
  })
end

return M

local M = {
"lukas-reineke/indent-blankline.nvim",
  enabled = false,
  event = "User FilePost",
  opts = {
    scope = {
      show_start = false,
    },
  }
}

function M.config(_, opts)
  require("ibl").setup(opts)
end

return M

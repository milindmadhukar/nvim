local M = {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "User FilePost",
  enabled = false,
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

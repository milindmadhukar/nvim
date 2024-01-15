local M = {
  "stevearc/oil.nvim",
  cmd = {"Oil"},
}

function M.config()
  require("oil").setup()
end

return M

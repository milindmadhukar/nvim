local M = {
	"kylechui/nvim-surround",
  enabled = false,
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
}

-- TODO: Explore

function M.config()
	require("surround").setup({})
end

return M

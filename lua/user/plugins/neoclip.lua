local M = {
	"AckslD/nvim-neoclip.lua",
	dependencies = {
		{ "nvim-telescope/telescope.nvim" },
	},
}

-- BUG: this does not show up in telescope

function M.config()
	require("neoclip").setup({})
end

return M

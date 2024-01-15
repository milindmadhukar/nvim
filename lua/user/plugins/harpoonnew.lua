local M = {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}

function M.config()
	require("harpoon").setup({
		save_on_toggle = true,
	})
end

return M

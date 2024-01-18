local M = {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
}

function M.config()
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"javascript",
			"typescript",
			"go",
			"python",
			"c",
			"cpp",
			"dockerfile",
			"rust",
			"lua",
			"cmake",
			"markdown",
			"bash",
			"html",
			"css",
			"java",
		},
		highlight = { enable = true },
		indent = { enable = true },
		autotag = {
			enable = true,
		},
	})
end

return M

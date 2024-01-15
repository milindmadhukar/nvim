local M = {
	{ "neovim/nvim-lspconfig", commit = "6f1d124bbcf03c4c410c093143a86415f46d16a0", event = "BufReadPre" }, -- enable LSP
	{ "williamboman/mason.nvim", commit = "08b2fd308e0107eab9f0b59d570b69089fd0b522" }, -- LSP/DAP/Format/Lint manager
	{ "williamboman/mason-lspconfig.nvim", commit = "c55d18f3947562e699d34d89681edbf9f0e250d3" },
	{ "nvimtools/none-ls.nvim" }, -- for formatters and linters
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			require("user.lsp.null-ls") -- require your null-ls config here (example below)
		end,
	},
}

return M

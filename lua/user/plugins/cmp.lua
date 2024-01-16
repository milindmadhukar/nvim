local M = {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- cmp sources plugins
		{
			"hrsh7th/cmp-buffer",
			event = "InsertEnter",
		},
		{
			"hrsh7th/cmp-path",
			event = "InsertEnter",
		}, -- path completions
		{
			"saadparwaiz1/cmp_luasnip",
			event = "InsertEnter",
		}, -- snippet completions
		{
			"hrsh7th/cmp-nvim-lsp",
			event = "InsertEnter",
		},
		{
			"hrsh7th/cmp-nvim-lua",
			event = "InsertEnter",
		},
		{
			"hrsh7th/cmp-emoji",
			event = "InsertEnter",
		},
		{
			"hrsh7th/cmp-calc",
			event = "InsertEnter",
		},
		{
			"zbirenbaum/copilot-cmp",
			event = "InsertEnter",
			config = function()
				require("copilot_cmp").setup()
			end,
		},
		-- snippets
		{ "L3MON4D3/LuaSnip" }, --snippet engine
		{ "rafamadriz/friendly-snippets" }, -- a bunch of snippets to use
	},
}

function M.config()
	require("user.cmp")
end

return M

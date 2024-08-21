local M = {
	{ "SmiteshP/nvim-navic" },
	{
		"SmiteshP/nvim-navbuddy",
		cmd = "NavBuddy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
			"numToStr/Comment.nvim", -- Optional
			"nvim-telescope/telescope.nvim", -- Optional
		},
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		event = "BufEnter",
		version = "*",
		opts = {},
	},
}

function M.config()
	require("nvim-navic").setup({
		icons = {
			File = " ",
			Module = " ",
			Namespace = " ",
			Package = " ",
			Class = " ",
			Method = " ",
			Property = " ",
			Field = " ",
			Constructor = " ",
			Enum = " ",
			Interface = " ",
			Function = " ",
			Variable = " ",
			Constant = " ",
			String = " ",
			Number = " ",
			Boolean = " ",
			Array = " ",
			Object = " ",
			Key = " ",
			Null = " ",
			EnumMember = " ",
			Struct = " ",
			Event = " ",
			Operator = " ",
			TypeParameter = " ",
		},
		highlight = true,
		separator = "  ",
		depth_limit = 0,
		depth_limit_indicator = "..",
		click = true,
	})
end

return M

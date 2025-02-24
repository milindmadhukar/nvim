local M = {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	dependencies = {
		"zbirenbaum/copilot-cmp",
	},
}

function M.config()
	require("copilot").setup({
		panel = {
			enabled = true, -- NOTE: False as cmp is enabled
			auto_refresh = false,

			keymap = {
				jump_prev = "[[",
				jump_next = "]]",
				accept = "<C-a>",
				refresh = "gr",
				open = "<M-CR>",
			},
			layout = {
				position = "bottom", -- | top | left | right
				ratio = 0.4,
			},
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			debounce = 75,
			keymap = {
				accept = "<M-a>",
				accept_word = false,
				accept_line = false,
				next = "<M-l>",
				prev = "<M-h>",
				dismiss = "<C-q>",
			},
		},

		filetypes = {
			lua = true,
			yaml = false,
			markdown = false,
			help = false,
			gitcommit = false,
			gitrebase = false,
			hgcommit = false,
			svn = false,
			cvs = false,
			["."] = false,
		},
		copilot_node_command = "node", -- Node.js version must be > 16.x
		server_opts_overrides = {},
	})

	vim.g.copilot_no_tab_map = true
	vim.g.copilot_assume_mapped = true
	vim.api.nvim_set_keymap("i", "<C-a>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
end

return M

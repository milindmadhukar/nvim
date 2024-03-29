local M = {
	"akinsho/toggleterm.nvim",
	event = "VeryLazy",
}

function M.config()
	require("toggleterm").setup({
		size = 10,
		open_mapping = [[<C-\>]], -- TODO: Change this to toggle all and use another mapping to open float
		hide_numbers = true,
		shade_filetypes = {},
		shade_terminals = false,
		shading_factor = 2,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "horizontal",
		close_on_exit = true,
		shell = vim.o.shell,
		float_opts = {
			border = "curved",
			winblend = 0,
			highlights = {
				border = "Normal",
				background = "Normal",
			},
		},
	})

	function _G.set_terminal_keymaps()
		local opts = { noremap = true }
		vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
		vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
	end

	vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

	local Terminal = require("toggleterm.terminal").Terminal

	local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

	function _LAZYGIT_TOGGLE()
		lazygit:toggle()
	end

	local lazydocker = Terminal:new({ cmd = "lazydocker", hidden = true, direction = "float" })

	function _LAZYDOCKER_TOGGLE()
		lazydocker:toggle()
	end

	local node = Terminal:new({ cmd = "node", hidden = true, direction = "float" })

	function _NODE_TOGGLE()
		node:toggle()
	end

	local ncdu = Terminal:new({ cmd = "ncdu", hidden = true, direction = "float" })

	function _NCDU_TOGGLE()
		ncdu:toggle()
	end

	local htop = Terminal:new({ cmd = "htop", hidden = true, direction = "float" })

	function _HTOP_TOGGLE()
		htop:toggle()
	end

	local vtop = Terminal:new({ cmd = "vtop --theme wizard", hidden = true, direction = "float" })

	function _VTOP_TOGGLE()
		vtop:toggle()
	end

	local python = Terminal:new({ cmd = "python3", hidden = true, direction = "float" })

	function _PYTHON_TOGGLE()
		python:toggle()
	end
end

return M

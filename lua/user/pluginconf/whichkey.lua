local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	vim.notify("WhichKey not found", "error")
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example<cmd>
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]whic
		winblend = 10,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^<cmd>", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	-- ["a"] = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
	["a"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
	["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
	["w"] = { "<cmd>w!<CR>", "Save" },
	["T"] = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble Diagnostics" },
	["q"] = { "<cmd>lua require('user.functions').smart_quit()<CR>", "Quit" },
	[";"] = { "<cmd>Alpha<CR>", "Dashboard" },
	["/"] = { "<cmd>lua require(\"Comment.api\").locked('toggle.linewise.current')()<CR>", "Comment" },
	["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
	["f"] = {
		"<cmd>Telescope find_files<cr>",
		"Find files",
	},
	["n"] = { "<cmd>lua require('telescope').extensions.notify.notify()<cr>", "Notifications" },
	["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
	["m"] = { "<cmd>MinimapToggle<CR>", "Toggle Minimap" },
	["P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
  ["C"] = { "<cmd>Copilot suggestion toggle_auto_trigger<cr>", "Toggle Copilot Text"},
	-- ["C"] = { "<cmd>CodiNew javascript<CR>", "Codi" },
	["z"] = { "<cmd>TZMinimalist<cr>", "Toggle narrow mode" },
	-- TODO: Switch to something that can run all file types
	["r"] = { "<cmd>TermExec cmd='clear && g++ % && ./a.out'<CR>", "Run C++ Program" },
	["L"] = { "<cmd>Lazy<cr>", "Lazy Menu" },

	Z = {
		["a"] = { "<cmd>TZAtaraxis<cr>", "Toggle ataraxis mode" },
		["m"] = { "<cmd>TZMinimalist<cr>", "Toggle minimalist mode" },
		["f"] = { "<cmd>TZFocus<cr>", "Toggle focus mode" },
		["z"] = { "<cmd>TZNarrow<cr>", "Toggle narrow mode" },
	},

	p = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
	},

	R = {
		name = "Refactoring",
		p = { "<cmd>lua require('refactoring').debug.printf({below = true})<CR>", "Printf" },
		c = { "<cmd>lua require('refactoring').debug.cleanup({})<CR>", "Cleanup" },
	},

	S = {
		name = "Spotify",
		n = { "<Plug>(SpotifySkip)", "Next" },
		b = { "<Plug>(SpotifyPrev)", "Previous" },
		s = { "<Plug>(SpotifySave)", "Save" },
		o = { "<cmd>Spotify<CR>", "Open" },
		d = { "<cmd>SpotifyDevices<CR>", "Devices" },
		p = { "<Plug>(SpotifyPause)", "Play/Pause" },
		S = { "<Plug>(SpotifyShuffle)", "Shuffle" },
	},

	g = {
		name = "Git",
		g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
		G = { "<cmd>Git<CR>", "Fugititve Git" },
		j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
		k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		u = {
			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
			"Undo Stage Hunk",
		},
		o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
		d = {
			"<cmd>Gitsigns diffthis HEAD<cr>",
			"Diff",
		},
	},

	--[[ h = { ]]
	--[[ 	name = "Hop", ]]
	--[[ 	l = { "<cmd>HopLine<cr>", "Hop to Line" }, ]]
	--[[ 	w = { "<cmd>HopWord<cr>", "Hop to Word" }, ]]
	--[[ 	c = { "<cmd>HopChar1<cr>", "Hop to Character" }, ]]
	--[[ }, ]]

	["H"] = { "<cmd>nohlsearch<CR>", "Clear highlighting" },

	l = {
		name = "LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
		d = {
			"<cmd>Telescope diagnostics bufnr=0<cr>",
			"Document Diagnostics",
		},
		w = {
			"<cmd>Telescope diagnostics<cr>",
			"Workspace Diagnostics",
		},
		f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		m = { "<cmd>Mason<cr>", "Mason" },
		j = {
			"<cmd>lua require('lspsaga.diagnostic').goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>",
			"Prev Diagnostic",
		},
		k = {
			"<cmd>lua require('lspsaga.diagnostic').goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>",
			"Previous Diagnostic",
		},
		l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
		q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
		--[[ r = { "<cmd>lua require('renamer').rename{empty=true,}<cr>", "Rename" }, ]]
		-- r = { "<cmd>Lspsaga rename<cr>", "Rename" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
		S = {
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			"Workspace Symbols",
		},
		F = { "<cmd>LspToggleAutoFormat<CR>", "Toggle Auto Format" },
	},
	s = {
		name = "Search",
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		-- f = { "<cmd>Telescope find_files<cr>", "Find File" },
		h = { "<cmd>Telescope help_tags<cr>", "Help" },
		i = { "<cmd>Telescope media_files<cr>", "Media" },
		l = { "<cmd>Telescope resume<cr>", "Last Search" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		C = { "<cmd>Telescope commands<cr>", "Commands" },
		s = { "<cmd>Telescope session-lens search_session<cr>", "Sessions" },
	},

	t = {
		name = "Trouble & Terminal",
		t = { "<cmd>ToggleTermToggleAll<CR>", "Toggle All Terminals" },
		T = { "<cmd>TodoTelescope<cr>", "Toggle Todo Telescope Menu" },
		w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace" },
		D = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document" },
		q = { "<cmd>TroubleToggle quickfix<cr>", "Show Quickfix(s)" },
		l = { "<cmd>TroubleToggle loclist<cr>", "Loclist" },
		r = { "<cmd>TroubleToggle lsp_references<cr>", "References" },

		n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
		H = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
		V = { "<cmd>lua _VTOP_TOGGLE()<cr>", "Vtop" },
		p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
		g = { "<cmd>lua _LAZYGIT_TOGGLE()<cr>", "Lazy Git" },
		d = { "<cmd>lua _LAZYDOCKER_TOGGLE()<cr>", "Lazy Docker" },
		f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
		h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
		v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
	},
	d = {
		name = "Debug",
		b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
		B = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
		c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
		C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
		d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
		S = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
		i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
		o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
		O = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
		p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
		r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
		s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
		q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
		g = { "<cmd>lua require('dap-go').debug_test()<CR>", "Golang Debug Test" },
	},
	b = {
		name = "Buffers",
		j = { "<cmd>BufferLinePick<cr>", "Jump" },
		f = { "<cmd>Telescope buffers<cr>", "Find" },
		b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
		n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
		-- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO<cmd> implement this for bufferline
		e = {
			"<cmd>BufferLinePickClose<cr>",
			"Pick which buffer to close",
		},
		h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
		l = {
			"<cmd>BufferLineCloseRight<cr>",
			"Close all to the right",
		},
		D = {
			"<cmd>BufferLineSortByDirectory<cr>",
			"Sort by directory",
		},
		L = {
			"<cmd>BufferLineSortByExtension<cr>",
			"Sort by language",
		},
	},

	h = {
		name = "Harpoon",
		a = { "<cmd>lua require('harpoon.mark').add_file()<CR>", "Add file" },
		m = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "Menu Toggle" },
		t = { "<cmd>Telescope harpoon marks<CR>", "Telescope Marks" },
		n = { '<cmd>lua require("harpoon.ui").nav_next()<CR>', "Next Harpoon Mark" },
		p = { '<cmd>lua require("harpoon.ui").nav_prev()<CR>', "Prev Harpoon Mark" },
		["1"] = { '<cmd>lua require("harpoon.ui").nav_file(1)<CR>', "Go to file 1" },
		["2"] = { '<cmd>lua require("harpoon.ui").nav_file(2)<CR>', "Go to file 2" },
		["3"] = { '<cmd>lua require("harpoon.ui").nav_file(3)<CR>', "Go to file 3" },
		["4"] = { '<cmd>lua require("harpoon.ui").nav_file(4)<CR>', "Go to file 4" },
		["5"] = { '<cmd>lua require("harpoon.ui").nav_file(5)<CR>', "Go to file 5" },
		["6"] = { '<cmd>lua require("harpoon.ui").nav_file(6)<CR>', "Go to file 6" },
		["7"] = { '<cmd>lua require("harpoon.ui").nav_file(7)<CR>', "Go to file 7" },
		["8"] = { '<cmd>lua require("harpoon.ui").nav_file(8)<CR>', "Go to file 8" },
		["9"] = { '<cmd>lua require("harpoon.ui").nav_file(9)<CR>', "Go to file 9" },
		["0"] = { '<cmd>lua require("harpoon.ui").nav_file(0)<CR>', "Go to file 0" },
	},
	-- NOTE: Maybe terminal support?
}

local vopts = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local vmappings = {
	["/"] = {
		"<ESC><CMD>lua require(\"Comment.api\").locked('comment.linewise')(vim.fn.visualmode())<CR>",
		"Comment",
	},
	r = {
		name = "Refactoring",
		e = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>", "Extract Function" },
		f = {
			"<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>",
			"Extract function to file",
		},
		v = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>", "Extract Variable" },
		i = { "<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>", "Inline Variable" },
		r = { "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", "Telescope Refactor" },
		V = { "<cmd>lua require('refactoring').debug.print_var({})<CR>", "Print Debug Variables" },
	},
	z = { "<cmd>'<,'>TZNarrow<cr>", "Toggle narrow mode" },
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)

local M = {
	"folke/which-key.nvim",
  event = "VeryLazy",
}

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
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	show_help = true, -- show help message on the command line when the popup is visible
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
	["a"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
	["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
	["w"] = { "<cmd>w!<CR>", "Save" },
	["T"] = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble Diagnostics" },
	["q"] = { "<cmd>lua require('user.functions').smart_quit()<CR>", "Quit" },
	[";"] = { "<cmd>Nvdash<CR>", "Dashboard" },
	["c"] = { "<cmd>lua require('utils').handle_buffer_close()<cr>", "Close Buffer" },
	["f"] = {
		"<cmd>Telescope find_files<cr>",
		"Find files",
	},
	["N"] = { "<cmd>lua require('telescope').extensions.notify.notify()<cr>", "Notifications" },
	["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
	["m"] = { "<cmd>MinimapToggle<CR>", "Toggle Minimap" },
	["P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
	-- ["C"] = { "<cmd>CodiNew javascript<CR>", "Codi" },
	["z"] = { "<cmd>TZMinimalist<cr>", "Toggle narrow mode" },
	-- TODO: Switch to something that can run all file types
	["r"] = { "<cmd>TermExec cmd='clear && g++ % && ./a.out'<CR>", "Run C++ Program" },
	["L"] = { "<cmd>Lazy<cr>", "Lazy Menu" },
	["S"] = { "<cmd>lua require('user.screenshot').generate_carbon_screenshot()<cr>", "Take screenshot" },

	["x"] = { "<cmd>lua require('user.functions').sourcefile()<CR>", "Source File" },

	["O"] = { "<cmd>Oil<cr>", "Oil" },

	Z = {
		["a"] = { "<cmd>TZAtaraxis<cr>", "Toggle ataraxis mode" },
		["m"] = { "<cmd>TZMinimalist<cr>", "Toggle minimalist mode" },
		["f"] = { "<cmd>TZFocus<cr>", "Toggle focus mode" },
		["z"] = { "<cmd>TZNarrow<cr>", "Toggle narrow mode" },
	},

	C = {
		name = "Copilot and ChatGPT",
		t = { "<cmd>Copilot suggestion toggle_auto_trigger<cr>", "Toggle Copilot Sugesstions" },
		d = { "<cmd>Copilot toggle<cr>", "Toggle Copilot" },
		p = { "<cmd>Copilot panel<cr>", "Show Panel" },
		S = { "<cmd>Copilot status<cr>", "Status" },

		c = { "<cmd>ChatGPT<cr>", "ChatGPT" },
		C = { "<cmd>ChatGPTCompleteCode<cr>", "ChatGPT Complete Code" },
		g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
		e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
		k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
		a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
		o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
		s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
		x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
		l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },

		A = { "<cmd>ChatGPTActAs<cr>", "ChatGPT Act As" },
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

	n = {
		name = "Neorg",
		["o"] = { "<cmd>Neorg workspace notes<cr>", "Open Notes workspace" },
		["g"] = { "<cmd>Neorg workspace twig<cr>", "Open TWiG workspace" },
		["j"] = { "<cmd>Neorg journal today<cr>", "Open today's journal" },
		["i"] = { "<cmd>Neorg index<cr>", "Index files" },
		["s"] = { "<cmd>Neorg sync-parsers<cr>", "Sync Neorg Parsers" },
		["e"] = { "<cmd>lua require('user.functions').export_neorg_to_md()<cr>", "Export file to markdown" },
		["c"] = { "<cmd>Neorg toggle-concealer<cr>", "Toggle Concealer (icons)" },
		["f"] = { "<cmd>Telescope neorg find_norg_files<cr>", "Find Norg Files" },
		-- TODO: Add Neorg telescope shortcuts.
	},

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
		f = { "<cmd>Format<cr>", "Format" },
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
		-- r = { "<cmd>Lspsaga rename<cr>", "Rename" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    h = {"<cmd>lua vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())<cr>", "Inlay Hints"},
		S = {
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			"Workspace Symbols",
		},
		F = { "<cmd>LspToggleAutoFormat<CR>", "Toggle Auto Format" },
    R = {"<cmd>LspRestart<cr>", "Restart LSP"},

	},
	s = {
		name = "Search",
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope themes<cr>", "Colorscheme" },
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
		a = { "<cmd>lua require('harpoon'):list():add()<CR>", "Add file" },
		m = { "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>", "Menu Toggle" },
		t = { "<cmd>Telescope harpoon marks<CR>", "Telescope Marks" },
		n = { '<cmd>lua require("harpoon"):list():prev()<CR>', "Next Harpoon Mark" },
		p = { '<cmd>lua require("harpoon"):list():next()<CR>', "Prev Harpoon Mark" },
		["1"] = { '<cmd>lua require("harpoon"):list():select(1)<CR>', "Go to file 1" },
		["2"] = { '<cmd>lua require("harpoon"):list():select(2)<CR>', "Go to file 2" },
		["3"] = { '<cmd>lua require("harpoon"):list():select(3)<CR>', "Go to file 3" },
		["4"] = { '<cmd>lua require("harpoon"):list():select(4)<CR>', "Go to file 4" },
		["5"] = { '<cmd>lua require("harpoon"):list():select(5)<CR>', "Go to file 5" },
		["6"] = { '<cmd>lua require("harpoon"):list():select(6)<CR>', "Go to file 6" },
		["7"] = { '<cmd>lua require("harpoon"):list():select(7)<CR>', "Go to file 7" },
		["8"] = { '<cmd>lua require("harpoon"):list():select(8)<CR>', "Go to file 8" },
		["9"] = { '<cmd>lua require("harpoon"):list():select(9)<CR>', "Go to file 9" },
		["0"] = { '<cmd>lua require("harpoon"):list():select(0)<CR>', "Go to file 0" },
	},

	o = {
		name = "Other",
		["t"] = { "<cmd>lua require('base46').toggle_transparency()<cr>", "Toggle Background Tranparency" },
		["c"] = { "<cmd>CodiNew javascript<cr>", "Javascript Scratchpad" },
		["b"] = { "<cmd>lua require('barbecue.ui').toggle()<cr>", "Toggle Barbecue" },
	},
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
		"<Plug>(comment_toggle_linewise_visual)",
		"Comment",
	},

	["S"] = { "<cmd>lua require('user.screenshot').generate_carbon_screenshot()<cr>", "Take screenshot" },

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

function M.config()
	local which_key = require("which-key")
	which_key.setup(setup)
	which_key.register(mappings, opts)
	which_key.register(vmappings, vopts)
end

return M

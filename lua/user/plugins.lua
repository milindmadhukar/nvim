local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

local plugins = {
	{ "nvim-lua/plenary.nvim", commit = "9ac3e9541bbabd9d73663d757e4fe48a675bb054" }, -- Useful lua functions used by lots of plugins
	{
		"numToStr/Comment.nvim",
		config = function()
			require("user.pluginconf.comment")
		end,
		lazy = false,
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "BufReadPost",
	},

	{ "nvim-tree/nvim-web-devicons" },
	{
		"nvim-tree/nvim-tree.lua",
		commit = "b1e074d2b52d45c8327b5b43a498b3d7e6c93b97",
		cmd = { "NvimTreeToggle" },
		config = function()
			require("user.pluginconf.nvim-tree")
		end,
	},
	{
		"akinsho/bufferline.nvim",
		event = "BufEnter",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("user.pluginconf.bufferline")
		end,
	},
	{ "moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56" },

	{
		"nvim-lualine/lualine.nvim",
		commit = "05d78e9fd0cdfb4545974a5aa14b1be95a86e9c9",
		config = function()
			require("user.pluginconf.lualine")
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		commit = "26f16d3bab1761d0d11117a8e431faba11a1b865",
		event = "BufEnter",
		config = function()
			require("user.pluginconf.toggleterm")
		end,
	},
	{
		"ahmedkhalf/project.nvim",
		commit = "8c6bad7d22eef1b71144b401c9f74ed01526a4fb",
		config = function()
			require("user.pluginconf.project")
		end,
		lazy = false,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		commit = "018bd04d80c9a73d399c1061fa0c3b14a7614399",
		event = "BufEnter",
		config = function()
			require("user.pluginconf.indentline")
		end,
	},
	{
		"goolord/alpha-nvim",
		commit = "1838ae926e8d49fe5330d1498ee8289ae2c340bc",
		config = function()
			require("user.pluginconf.alpha")
		end,
		lazy = false,
	},
	{
		"folke/which-key.nvim",
		config = function()
			require("user.pluginconf.whichkey")
		end,
		lazy = false,
	},

	-- Colorschemes
	{ "xiyaowong/nvim-transparent" },
	{ "folke/tokyonight.nvim", lazy = false },
	{ "lunarvim/darkplus.nvim" },
	{ "Shadorain/shadotheme" },
	{ "LunarVim/synthwave84.nvim", lazy = "false" },
	{ "catppuccin/nvim", name = "catppuccin", lazy = "false" },

	{
		"hrsh7th/nvim-cmp",
		commit = "3ac8d6cd29c74ff482d8ea47d45e5081bfc3f5ad",
		event = "InsertEnter",
		dependencies = {
			-- cmp sources plugins
			{
				{
					"windwp/nvim-autopairs",
					commit = "7747bbae60074acf0b9e3a4c13950be7a2dff444",
					event = "InsertEnter",
					config = function()
						require("user.pluginconf.autopairs")
					end,
				}, -- Autopairs, integrates with both cmp and treesitter
				-- cmp plugins
				{
					"hrsh7th/cmp-buffer",
					commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
					event = "InsertEnter",
				}, -- buffer completions
				{
					"hrsh7th/cmp-path",
					commit = "447c87cdd6e6d6a1d2488b1d43108bfa217f56e1",
					event = "InsertEnter",
				}, -- path completions
				{ "saadparwaiz1/cmp_luasnip", commit = "18095520391186d634a0045dacaa346291096566" }, -- snippet completions
				{ "hrsh7th/cmp-nvim-lsp", commit = "0e6b2ed705ddcff9738ec4ea838141654f12eeef" },
				{ "hrsh7th/cmp-nvim-lua", commit = "f12408bdb54c39c23e67cab726264c10db33ada8" },
				{ "hrsh7th/cmp-emoji" },
				{ "hrsh7th/cmp-calc" },
				-- snippets
				{ "L3MON4D3/LuaSnip" }, --snippet engine
				{ "rafamadriz/friendly-snippets" }, -- a bunch of snippets to use
				-- use({ "pheianox/solidjs-snippets" })
				{ "solidjs-community/solid-snippets" },
			},
		},
		config = function()
			require("user.cmp")
		end,
	},

	-- LSP
	{ "neovim/nvim-lspconfig", commit = "6f1d124bbcf03c4c410c093143a86415f46d16a0", event = "BufReadPre" }, -- enable LSP
	{ "williamboman/mason.nvim", commit = "08b2fd308e0107eab9f0b59d570b69089fd0b522" }, -- LSP/DAP/Format/Lint manager
	{ "williamboman/mason-lspconfig.nvim", commit = "c55d18f3947562e699d34d89681edbf9f0e250d3" },
	{ "nvimtools/none-ls.nvim", commit = "bec2b07872d5112fd723a23fc2a69c70fec4d673" }, -- for formatters and linters
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

	{
		"SmiteshP/nvim-navic",
		event = "BufEnter",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("user.pluginconf.navic")
		end,
	},

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
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {},
	},

	{
		"RRethy/vim-illuminate",
		commit = "a2907275a6899c570d16e95b9db5fd921c167502",
		event = "BufEnter",
		config = function()
			require("user.pluginconf.illuminate")
		end,
	},

	{
		"kosayoda/nvim-lightbulb",
		dependencies = { "antoinemadec/FixCursorHold.nvim" },
		config = function()
			require("user.pluginconf.lightbulb")
		end,
	},

	-- Telescope
	{ "nvim-telescope/telescope.nvim", lazy = false },

	{
		"nvim-telescope/telescope-ui-select.nvim",
		opt = true,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("user.pluginconf.treesitter")
		end,
	},
	-- Git
	{
		"lewis6991/gitsigns.nvim",
		commit = "c18b7ca0b5b50596722f3a1572eb9b8eb520c0f1",
		init = function()
			-- load gitsigns only when a git file is opened
			vim.api.nvim_create_autocmd({ "BufRead" }, {
				group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
				callback = function()
					vim.fn.system("git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse")
					if vim.v.shell_error == 0 then
						vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
						vim.schedule(function()
							require("lazy").load({ plugins = { "gitsigns.nvim" } })
						end)
					end
				end,
			})
		end,

		config = function()
			require("user.pluginconf.gitsigns")
		end,
	},
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		cmd = "Git",
	},

	-- DAP

	{
		"mfussenegger/nvim-dap",
		commit = "56118cee6af15cb9ddba9d080880949d8eeb0c9f",
		event = "BufEnter",
		config = function()
			require("user.pluginconf.dap")
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		commit = "4ce7b97dd8f50b4f672948a34bf8f3a56214fdb8",
	},

	{
		"leoluz/nvim-dap-go",
		ft = "go",
	},

	{
		"mfussenegger/nvim-dap-python",
	},

	-- Misc
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("user.pluginconf.colorizer")
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "BufEnter",
		config = function()
			require("user.pluginconf.todocomments")
		end,
	}, -- NOTE: Not actively maintained
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	{
		"Pocco81/true-zen.nvim",
		cmd = { "TZFocus", "TZNarrow", "TZAtaraxis", "TZMinimalist" },
		config = function()
			require("user.pluginconf.zenmode")
		end,
	},
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		event = "BufEnter",
	},

	{
		"ThePrimeagen/harpoon",
		event = "VeryLazy",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
		config = function()
			require("user.pluginconf.harpoon")
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascriptreact", "typescriptreact", "svelte", "tsx", "jsx" },
		event = "InsertEnter",
	},

	{
		"andweeb/presence.nvim",
		config = function()
			require("user.pluginconf.presence")
		end,
	},

	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		ft = "markdown",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
	},

	{
		"wfxr/minimap.vim",
		build = "cargo install --locked code-minimap",
		cmd = "MinimapToggle",
	},

	{
		"metakirby5/codi.vim",
		cmd = { "Codi", "CodiNew", "CodiSelect", "CodiExpand" },
	}, -- Interactive scratchpad,

	{
		"ThePrimeagen/vim-be-good",
		cmd = "VimBeGood",
	},

	{
		"zbirenbaum/copilot-cmp",
		event = "InsertEnter",
		config = function()
			require("copilot_cmp").setup()
		end,

		dependencies = {
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			config = function()
				require("user.pluginconf.copilot")
			end,
		},
	},

	-- Rust
	{ "rust-lang/rust.vim", ft = "rust" },
	{ "simrat39/rust-tools.nvim", ft = "rust" }, -- TODO: Configure this

	{ "ellisonleao/glow.nvim", config = true, cmd = "Glow" },

	{
		"rcarriga/nvim-notify",
		config = function()
			require("user.pluginconf.notify")
		end,

		lazy = false,
	},

	{
		"laytan/cloak.nvim",
		config = function()
			require("user.pluginconf.cloak")
		end,
	},

	-- UI
	{
		"folke/noice.nvim",
		enabled = false,
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
		},
		config = function()
			require("user.pluginconf.noice")
		end,
	},

	{
		"stevearc/dressing.nvim",
		config = function()
			require("user.pluginconf.dressing")
		end,
		event = "VeryLazy",
	},

	{
		"tamton-aquib/zone.nvim",
		enabled = false,
		config = function()
			require("zone").setup({
				style = "dvd",
				after = 120, -- Idle timeout
				exclude_filetypes = { "TelescopePrompt", "NvimTree", "neo-tree", "dashboard", "lazy", "alpha" },
				-- More options to come later

				treadmill = {
					direction = "left",
					headache = true,
					tick_time = 30, -- Lower, the faster
					-- Opts for Treadmill style
				},
				epilepsy = {
					stage = "aura", -- "aura" or "ictal"
					tick_time = 100,
				},
				dvd = {
					-- text = {"line1", "line2", "line3", "etc"}
					tick_time = 50,
					-- Opts for Dvd style
				},
			})
		end,
	},

	{
		"karb94/neoscroll.nvim",
		enabled = true,
		-- NOTE: Disabled coz animation seems too slow for me, i think default jumps are ok, idk
		config = function()
			require("neoscroll").setup({
				-- All these keys will be mapped to their corresponding default scrolling animation
				mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
				hide_cursor = true, -- Hide cursor while scrolling
				stop_eof = true, -- Stop at <EOF> when scrolling downwards
				respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
				cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
				easing_function = nil, -- Default easing function
				pre_hook = nil, -- Function to run before the scrolling animation starts
				post_hook = nil, -- Function to run after the scrolling animation ends
				performance_mode = false, -- Disable "Performance Mode" on all buffers.
			})
		end,
	},

	{
		"gen740/SmoothCursor.nvim",
    config = function()
      require("user.pluginconf.smoothcursor")
    end,
	},

	-- use {
	--   'KadoBOT/nvim-spotify',
	--   dependencies = 'nvim-telescope/telescope.nvim',
	--   build = 'cargo install spotify-tui && make',
	-- }
	--
}

local opts = {
	defaults = { lazy = false },
	install = { colorscheme = { "tokyonight-moon" } },
	checker = { enabled = true, notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	debug = false,
	ui = {
		border = "rounded",
	},
}

lazy.setup(plugins, opts)

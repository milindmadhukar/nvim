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
			require("user.plugins.illuminate")
		end,
	},

	{
		"kosayoda/nvim-lightbulb",
		dependencies = { "antoinemadec/FixCursorHold.nvim" },
		config = function()
			require("user.plugins.lightbulb")
		end,
	},

	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		config = function()
			require("user.plugins.jdtls")
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
			require("user.plugins.treesitter")
		end,
	},
	-- Git
	{
		"lewis6991/gitsigns.nvim",
		commit = "c18b7ca0b5b50596722f3a1572eb9b8eb520c0f1",

		config = function()
			require("user.plugins.gitsigns")
		end,
	},


	{ "metakirby5/codi.vim",
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
				require("user.plugins.copilot")
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
			require("user.plugins.notify")
		end,

		lazy = false,
	},

	{
		"laytan/cloak.nvim",
		config = function()
			require("user.plugins.cloak")
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
			require("user.plugins.noice")
		end,
	},

	{
		"stevearc/dressing.nvim",
		config = function()
			require("user.plugins.dressing")
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

	-- Smooth scrolling
	{
		"karb94/neoscroll.nvim",
		enabled = false,
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
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",

			-- optional
			"rcarriga/nvim-notify",
		},
		opts = {
			-- configuration goes here
		},
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
	dev = {
		-- directory where you store your local plugin projects
		path = "/home/milind/Desktop/Code/NeovimPlugins",
		---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
		patterns = {}, -- For example {"folke"}
		fallback = false, -- Fallback to git when local plugin doesn't exist
	},
	debug = false,
	ui = {
		border = "rounded",
	},
}

lazy.setup(plugins, opts)

local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

local au_packer = vim.api.nvim_create_augroup("packer_autoconf", { clear = true })
vim.api.nvim_create_autocmd(
	"BufWritePost",
	{
		group = au_packer,
		pattern = "plugins.lua",
		command = "source <afile> | PackerSync",
		desc = "Reloads nvim when you save plugins.lua",
	}
)

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})
-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here

	use({ "wbthomason/packer.nvim", commit = "00ec5adef58c5ff9a07f11f45903b9dbbaa1b422" }) -- Have packer manage itself
	use({ "nvim-lua/plenary.nvim", commit = "968a4b9afec0c633bc369662e78f8c5db0eba249" }) -- Useful lua functions used by lots of plugins
	use({ "windwp/nvim-autopairs", commit = "fa6876f832ea1b71801c4e481d8feca9a36215ec" }) -- Autopairs, integrates with both cmp and treesitter
	use({ "numToStr/Comment.nvim", commit = "ae8c440fe98c65f3a941d6fc6de75538c5c1ecde", event = "BufRead" })
	use({
		"JoosepAlviste/nvim-ts-context-commentstring",
		commit = "88343753dbe81c227a1c1fd2c8d764afb8d36269",
		event = "BufReadPost",
	})
	use({ "kyazdani42/nvim-web-devicons", commit = "8d2c5337f0a2d0a17de8e751876eeb192b32310e" })
	use({ "kyazdani42/nvim-tree.lua", commit = "bdb6d4a25410da35bbf7ce0dbdaa8d60432bc243" })
	use({ "akinsho/bufferline.nvim", commit = "c78b3ecf9539a719828bca82fc7ddb9b3ba0c353" })
	use({ "moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56" })
	use({ "nvim-lualine/lualine.nvim", commit = "3362b28f917acc37538b1047f187ff1b5645ecdd" })
	use({ "akinsho/toggleterm.nvim", commit = "aaeed9e02167c5e8f00f25156895a6fd95403af8" })
	use({ "ahmedkhalf/project.nvim", commit = "541115e762764bc44d7d3bf501b6e367842d3d4f" })
	use({ "lewis6991/impatient.nvim", commit = "969f2c5c90457612c09cf2a13fee1adaa986d350" })
	use({
		"lukas-reineke/indent-blankline.nvim",
		commit = "6177a59552e35dfb69e1493fd68194e673dc3ee2",
		event = "BufEnter",
	})
	use({ "goolord/alpha-nvim", commit = "ef27a59e5b4d7b1c2fe1950da3fe5b1c5f3b4c94" })
	use({ "folke/which-key.nvim" })

	-- Colorschemes
	use({ "xiyaowong/nvim-transparent" })
	use({ "folke/tokyonight.nvim" })
	use({ "lunarvim/darkplus.nvim" })
	use({ "Shadorain/shadotheme" })
	use({ "LunarVim/synthwave84.nvim" })

	-- cmp plugins
	use({ "hrsh7th/nvim-cmp", commit = "df6734aa018d6feb4d76ba6bda94b1aeac2b378a" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer", commit = "62fc67a2b0205136bc3e312664624ba2ab4a9323" }) -- buffer completions
	use({ "hrsh7th/cmp-path", commit = "466b6b8270f7ba89abd59f402c73f63c7331ff6e" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip", commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp", commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8" })
	use({ "hrsh7th/cmp-nvim-lua", commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21" })
	use({ "hrsh7th/cmp-emoji" })
	use({
		"zbirenbaum/copilot-cmp",
		module = "copilot_cmp",
	})
	-- NOTE: Still in development

	-- snippets
	use({ "L3MON4D3/LuaSnip" }) --snippet engine
	use({ "rafamadriz/friendly-snippets" }) -- a bunch of snippets to use

	-- LSP
	use({ "neovim/nvim-lspconfig", commit = "148c99bd09b44cf3605151a06869f6b4d4c24455" }) -- enable LSP
	use({ "williamboman/mason.nvim" }) -- LSP/DAP/Format/Lint manager
	use({ "williamboman/mason-lspconfig.nvim" })
	-- use({ "williamboman/nvim-lsp-installer", commit = "e9f13d7acaa60aff91c58b923002228668c8c9e6" }) -- simple to use language server installer
	use({ "jose-elias-alvarez/null-ls.nvim", commit = "ff40739e5be6581899b43385997e39eecdbf9465" }) -- for formatters and linters
	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
		commit = "11eff5fef43c6aa4205f0fd9bc7aa84ee4c419b7",
		cmd = { "Lspsaga" },
	})
	use({
		"RRethy/vim-illuminate",
		commit = "c82e6d04f27a41d7fdcad9be0bce5bb59fcb78e5",
		event = "BufEnter",
		config = function()
			vim.g.Illuminate_ftblacklist = { "alpha", "NvimTree" }
			vim.api.nvim_set_keymap(
				"n",
				"<a-n>",
				'<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
				{ noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<a-p>",
				'<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
				{ noremap = true }
			)
		end,
	})

	-- Telescope
	use({ "nvim-telescope/telescope.nvim", commit = "d96eaa914aab6cfc4adccb34af421bdd496468b0" })
	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		commit = "518e27589c0463af15463c9d675c65e464efc2fe",
	})
	-- Git
	use({ "lewis6991/gitsigns.nvim" })
	use({ "tpope/vim-fugitive" })

	-- DAP
	use({
		"mfussenegger/nvim-dap",
		commit = "014ebd53612cfd42ac8c131e6cec7c194572f21d",
		event = "BufEnter",
	})
	use({
		"rcarriga/nvim-dap-ui",
		commit = "d76d6594374fb54abf2d94d6a320f3fd6e9bb2f7",
		event = "BufEnter",
	})
	use({
		"leoluz/nvim-dap-go",
		ft = { "go" },
	})

	-- Misc
	use("norcalli/nvim-colorizer.lua")
	use("folke/todo-comments.nvim") -- NOTE: Not actively maintained
	use({
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	})
	use({
		"Pocco81/true-zen.nvim",
		cmd = { "TZFocus", "TZNarrow", "TZAtaraxis", "TZMinimalist" },
	})
	-- use("folke/zen-mode.nvim")
	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		event = "BufEnter",
	})
	use({
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascriptreact", "typescriptreact", "svelte", "tsx", "jsx" },
		event = "InsertEnter",
	})

	use({ "andweeb/presence.nvim" })

	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
	})

	use({
		"wfxr/minimap.vim",
		run = "cargo install --locked code-minimap",
		cmd = "MinimapToggle",
	})

	use({ "github/copilot.vim" })
	-- TODO: This is under early development, it will replace copilot.vim
	use({
		"zbirenbaum/copilot.lua",
		event = { "VimEnter" },
		config = function()
			vim.defer_fn(function()
				require("copilot").setup()
			end, 100)
		end,
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)

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
vim.api.nvim_create_autocmd("BufWritePost", {
  group = au_packer,
  pattern = "plugins.lua",
  command = "source <afile> | PackerSync",
  desc = "Reloads nvim when you save plugins.lua",
})

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
  git = {
    clone_timeout = 300,
  },
})
-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here

  use({ "wbthomason/packer.nvim", commit = "6afb67460283f0e990d35d229fd38fdc04063e0a" }) -- Have packer manage itself
  use({ "nvim-lua/plenary.nvim", commit = "4b7e52044bbb84242158d977a50c4cbcd85070c7" }) -- Useful lua functions used by lots of plugins
  use({ "windwp/nvim-autopairs", commit = "4fc96c8f3df89b6d23e5092d31c866c53a346347" }) -- Autopairs, integrates with both cmp and treesitter
  use({ "numToStr/Comment.nvim", commit = "97a188a98b5a3a6f9b1b850799ac078faa17ab67", event = "BufRead" })
  use({
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = "4d3a68c41a53add8804f471fcc49bb398fe8de08",
    event = "BufReadPost",
  })
  use({ "kyazdani42/nvim-web-devicons", commit = "563f3635c2d8a7be7933b9e547f7c178ba0d4352" })
  use({ "kyazdani42/nvim-tree.lua", commit = "7282f7de8aedf861fe0162a559fc2b214383c51c" })
  use({ "akinsho/bufferline.nvim", commit = "83bf4dc7bff642e145c8b4547aa596803a8b4dc4" })
  use({ "moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56" })
  use({ "nvim-lualine/lualine.nvim", commit = "a52f078026b27694d2290e34efa61a6e4a690621" })
  use({ "akinsho/toggleterm.nvim", commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda" })
  use({ "ahmedkhalf/project.nvim", commit = "628de7e433dd503e782831fe150bb750e56e55d6" })
  use({ "lewis6991/impatient.nvim", commit = "b842e16ecc1a700f62adb9802f8355b99b52a5a6" })
  use({
    "lukas-reineke/indent-blankline.nvim",
    commit = "db7cbcb40cc00fc5d6074d7569fb37197705e7f6",
    event = "BufEnter",
  })
  use({ "goolord/alpha-nvim", commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31" })
  use({ "folke/which-key.nvim" })

  -- Colorschemes
  use({ "xiyaowong/nvim-transparent" })
  use({ "folke/tokyonight.nvim" })
  use({ "lunarvim/darkplus.nvim" })
  use({ "Shadorain/shadotheme" })
  use({ "LunarVim/synthwave84.nvim" })
  use({ "catppuccin/nvim", as = "catppuccin" })

  -- cmp plugins
  use({ "hrsh7th/nvim-cmp", commit = "b0dff0ec4f2748626aae13f011d1a47071fe9abc" }) -- The completion plugin
  use({ "hrsh7th/cmp-buffer", commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa" }) -- buffer completions
  use({ "hrsh7th/cmp-path", commit = "447c87cdd6e6d6a1d2488b1d43108bfa217f56e1" }) -- path completions
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
  use({ "neovim/nvim-lspconfig", commit = "f11fdff7e8b5b415e5ef1837bdcdd37ea6764dda" }) -- enable LSP
  use({ "williamboman/mason.nvim", commit = "c2002d7a6b5a72ba02388548cfaf420b864fbc12" }) -- LSP/DAP/Format/Lint manager
  use({ "williamboman/mason-lspconfig.nvim", commit = "0051870dd728f4988110a1b2d47f4a4510213e31" })
  use({ "jose-elias-alvarez/null-ls.nvim", commit = "c0c19f32b614b3921e17886c541c13a72748d450" }) -- for formatters and linters
  use({
    "RRethy/vim-illuminate",
    commit = "a2e8476af3f3e993bb0d6477438aad3096512e42",
    event = "BufEnter",
    -- disable = true, -- TODO: Enable when good performance
  })

  use({
    "kosayoda/nvim-lightbulb",
    requires = "antoinemadec/FixCursorHold.nvim",
  })

  use({
    "glepnir/lspsaga.nvim",
    disable = true,
    branch = "main",
    commit = "11eff5fef43c6aa4205f0fd9bc7aa84ee4c419b7",
    cmd = { "Lspsaga" },
  })

  -- Telescope
  use({ "nvim-telescope/telescope.nvim", commit = "76ea9a898d3307244dce3573392dcf2cc38f340f" })

  use({
    "nvim-telescope/telescope-ui-select.nvim",
    opt = true,
  })

  -- UI
  use({"rcarriga/nvim-notify"})

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    commit = "8e763332b7bf7b3a426fd8707b7f5aa85823a5ac",
  })
  -- Git
  use({
    "lewis6991/gitsigns.nvim",
    commit = "f98c85e7c3d65a51f45863a34feb4849c82f240f",
    opt = true,
    setup = function()
      vim.api.nvim_create_autocmd({ "BufAdd", "VimEnter" }, {
        callback = function()
          local function onexit(code, _)
            if code == 0 then
              vim.schedule(function()
                require("packer").loader("gitsigns.nvim")
              end)
            end
          end

          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          if lines ~= { "" } then
            vim.loop.spawn("git", {
              args = {
                "ls-files",
                "--error-unmatch",
                vim.fn.expand("%"),
              },
            }, onexit)
          end
        end,
      })
    end,
  })
  use({ "tpope/vim-fugitive" })

  -- DAP
  use({
    "mfussenegger/nvim-dap",
    commit = "014ebd53612cfd42ac8c131e6cec7c194572f21d",
    -- event = "BufEnter",
  })
  use({
    "rcarriga/nvim-dap-ui",
    commit = "d76d6594374fb54abf2d94d6a320f3fd6e9bb2f7",
    -- event = "BufEnter",
  })
  use({
    "leoluz/nvim-dap-go",
    -- ft = { "go" },
  })
  use({
    "mfussenegger/nvim-dap-python",
    -- ft = { "python" },
    -- event = "BufEnter",
  })

  -- Misc
  use({ "stevearc/dressing.nvim" })
  use({ "norcalli/nvim-colorizer.lua" })
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
    disable = true,
    event = "BufEnter",
  })

  use({
    "ThePrimeagen/harpoon",
    requires = {
      { "nvim-lua/plenary.nvim" },
    },
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

  use({
    "metakirby5/codi.vim",
    cmd = { "Codi", "CodiNew", "CodiSelect", "CodiExpand" },
  }) -- Interactive scratchpad

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

  use({
    "phaazon/mind.nvim",
    branch = "v2.2",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("mind").setup()
    end,
    cmd = { "MindOpenMain", "MindOpenProject", "MindReloadState" }, -- TODO: Try it out when 0.8, doesn't seem to be working yet
  })

  -- Session management
  use({
    "rmagatti/auto-session",
    disable = true,
  })
  use({
    "rmagatti/session-lens",
    requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
    disable = true,
  })

  -- use {
  --   'KadoBOT/nvim-spotify',
  --   requires = 'nvim-telescope/telescope.nvim',
  --   run = 'cargo install spotify-tui && make',
  -- }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

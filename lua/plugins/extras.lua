local M = {
  {
    "rafcamlet/nvim-luapad",
    cmd = { "Luapad", "Lua", "LuaRun" },
  },

  {
    "tpope/vim-fugitive",
    -- `event = "VeryLazy"` was here too, which sourced ~7k lines of vimscript
    -- on every session whether or not fugitive was used. The command list is
    -- what actually needs to exist up front; fugitive defines the rest itself
    -- once loaded.
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Gedit", "Ggrep", "Glgrep", "Gclog", "Gllog", "GBrowse", "GMove", "GRename", "GDelete", "GRemove" },
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    -- opts is required: trouble v3 registers the :Trouble command from
    -- setup(), which lazy only calls when a spec has opts/config.
    opts = {},
  },

  {
    -- Upstream now requires nvim 0.12 and lewis6991/async.nvim; without that
    -- dependency every refactoring module fails with `module 'async' not found`.
    -- plenary/treesitter are no longer dependencies, and setup() is optional.
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "lewis6991/async.nvim" },
    cmd = "Refactor",
    keys = {
      { "<leader>R", mode = "n" },
      { "<leader>r", mode = "x" },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascriptreact", "typescriptreact", "svelte", "vue" },
    opts = {},
  },

  {
    "metakirby5/codi.vim",
    cmd = { "Codi", "CodiNew", "CodiSelect", "CodiExpand" },
  }, -- Interactive scratchpad,

  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },

  { "ellisonleao/glow.nvim",    config = true, cmd = "Glow" },

  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",
      -- nvim-notify was listed here as leetcode's optional notification
      -- backend. leetcode never requires it directly -- it just calls
      -- vim.notify, which snacks.notifier answers now.
    },
    opts = {
      -- configuration goes here
    },
  },

  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
  },

  {
    "mawkler/modicator.nvim",
    init = function()
      -- These are required for Modicator to work
      vim.o.cursorline = true
      vim.o.number = true
      vim.o.termguicolors = true
    end,
    -- `init` above already sets the three options modicator requires, so the
    -- plugin itself only has to be around by the time a mode changes.
    event = "VeryLazy",
    opts = {},
  },

  {
    "NStefan002/2048.nvim",
    cmd = "Play2048",
    config = true,
  },
}

return M

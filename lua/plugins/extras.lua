local M = {
  {
    "rafcamlet/nvim-luapad",
    cmd = { "Luapad", "Lua", "LuaRun" },
  },

  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    cmd = "Git",
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
    "wfxr/minimap.vim",
    build = "cargo install --locked code-minimap",
    cmd = { "Minimap", "MinimapToggle", "MinimapClose", "MinimapRefresh" },
  },

  {
    "metakirby5/codi.vim",
    cmd = { "Codi", "CodiNew", "CodiSelect", "CodiExpand" },
  }, -- Interactive scratchpad,

  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },

  -- rust-tools.nvim was archived in 2024; rustaceanvim is its successor and
  -- configures rust_analyzer itself (so it is absent from plugins/lsp/servers.lua).
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    ft = "rust",
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

      -- optional
      "rcarriga/nvim-notify",
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
    event = "BufEnter",
    opts = {},
    config = function()
      require("modicator").setup({})
    end,
  },

  {
    "NStefan002/2048.nvim",
    cmd = "Play2048",
    config = true,
  },
}

return M

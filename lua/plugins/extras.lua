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
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascriptreact", "typescriptreact", "svelte", "tsx", "jsx" },
    event = "InsertEnter",
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

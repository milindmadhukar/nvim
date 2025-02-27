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
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },

  {
    "OXY2DEV/markview.nvim",
    -- lazy = false, -- Recommended
    ft = "markdown", -- If you decide to lazy-load anyway

    dependencies = {
      -- You will not need this if you installed the
      -- parsers manually
      -- Or if the parsers are in your $RUNTIMEPATH
      "nvim-treesitter/nvim-treesitter",

      "nvim-tree/nvim-web-devicons"
    }
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

  { "rust-lang/rust.vim",       ft = "rust" },
  { "simrat39/rust-tools.nvim", ft = "rust" }, -- TODO: Configure this

  { "ellisonleao/glow.nvim",    config = true, cmd = "Glow" },

  {
    "tamton-aquib/zone.nvim",
    enabled = false,
    config = function()
      require("zone").setup({
        style = "dvd",
        after = 500, -- Idle timeout
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

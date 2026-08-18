return {
  -- Useful lua functions used by lots of plugins
  { "nvim-lua/plenary.nvim" },

  {
    -- Renamed from echasnovski/mini.nvim in 2026.
    "nvim-mini/mini.nvim",
    version = "*",
    lazy = false,
    priority = 100,
    config = function()
      -- Single icon provider: mini.icons serves plugins that ask for
      -- nvim-web-devicons too, so the two are no longer loaded side by side.
      require("mini.icons").setup()
      require("mini.icons").mock_nvim_web_devicons()

      -- Replaces wfxr/minimap.vim, which shelled out to code-minimap through
      -- `:w !cmd` and so tripped Neovim's "Press any key to continue" prompt
      -- on every refresh. mini.map renders in-process, no external binary.
      local map = require "mini.map"
      map.setup {
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic(),
          map.gen_integration.gitsigns(),
        },
        symbols = { encode = map.gen_encode_symbols.dot "4x2" },
        window = { winblend = 25, show_integration_count = false },
      }
    end,
  },

  -- Kept only because NvChad's own specs list it as a dependency; mini.icons
  -- mocks the module, so this never actually loads its own icon tables.
  { "nvim-tree/nvim-web-devicons", lazy = true },

  { "moll/vim-bbye", cmd = { "Bdelete", "Bwipeout" } },
}

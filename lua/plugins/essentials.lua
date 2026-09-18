return {
  -- Useful lua functions used by lots of plugins
  { "nvim-lua/plenary.nvim" },

  {
    -- Renamed from echasnovski/mini.nvim in 2026.
    "nvim-mini/mini.nvim",
    version = "*",
    -- mini.nvim is one repo holding many modules, so the spec is eager but the
    -- setup calls are not: only mini.icons has to exist before the first
    -- window is drawn (it stands in for nvim-web-devicons, which nvim-tree,
    -- telescope and lualine all ask for while painting). The rest are keymap-
    -- and command-driven and cost nothing by waiting for VeryLazy.
    lazy = false,
    priority = 100,
    config = function()
      -- Single icon provider: mini.icons serves plugins that ask for
      -- nvim-web-devicons too, so the two are no longer loaded side by side.
      require("mini.icons").setup()
      require("mini.icons").mock_nvim_web_devicons()

      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        desc = "Set up the mini.nvim modules that are not needed to draw the UI",
        callback = function()
          -- Treesitter-aware textobjects: `af`/`if` (function), `ac`/`ic`
          -- (class), `aa`/`ia` (argument), and the usual bracket/quote pairs,
          -- all with next/last variants. Nothing else here provides them.
          require("mini.ai").setup { n_lines = 500 }

          -- `sa`/`sd`/`sr` add/delete/replace surroundings. This shadows the
          -- built-in `s` (substitute); `cl` is the equivalent and `s` was
          -- unmapped in core/mappings.lua anyway.
          require("mini.surround").setup()

          -- Replaces wfxr/minimap.vim, which shelled out to code-minimap
          -- through `:w !cmd` and so tripped Neovim's "Press any key to
          -- continue" prompt on every refresh. mini.map renders in-process,
          -- no external binary.
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
      })
    end,
  },

  -- Kept only because NvChad's own specs list it as a dependency; mini.icons
  -- mocks the module, so this never actually loads its own icon tables.
  { "nvim-tree/nvim-web-devicons", lazy = true },

  { "moll/vim-bbye", cmd = { "Bdelete", "Bwipeout" } },
}

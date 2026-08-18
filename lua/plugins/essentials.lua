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
    end,
  },

  -- Kept only because NvChad's own specs list it as a dependency; mini.icons
  -- mocks the module, so this never actually loads its own icon tables.
  { "nvim-tree/nvim-web-devicons", lazy = true },

  { "moll/vim-bbye", cmd = { "Bdelete", "Bwipeout" } },
}

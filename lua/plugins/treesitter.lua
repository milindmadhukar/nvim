return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    matchup = {
      enable = true,              -- mandatory, false will disable the whole extension
      disable = { "c", "ruby" },  -- optional, list of languages that will be disabled
      -- [options]
    },
  },
}

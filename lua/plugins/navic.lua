-- NOTE: LSP symbol breadcrumbs / navigation
--
-- barbecue.nvim was removed here: archived upstream since 2024-08.
-- navic is attached per-buffer from the LspAttach autocmd in
-- plugins/lsp/configs/lspconfig.lua, and rendered by lualine.
return {
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = {
      icons = {
        File = " ", Module = " ", Namespace = " ", Package = " ",
        Class = " ", Method = " ", Property = " ", Field = " ",
        Constructor = " ", Enum = " ", Interface = " ", Function = " ",
        Variable = " ", Constant = " ", String = " ", Number = " ",
        Boolean = " ", Array = " ", Object = " ", Key = " ",
        Null = " ", EnumMember = " ", Struct = " ", Event = " ",
        Operator = " ", TypeParameter = " ",
      },
      highlight = true,
      separator = "  ",
      depth_limit = 0,
      depth_limit_indicator = "..",
      click = true,
      lsp = { auto_attach = false },
    },
  },
  {
    -- navbuddy registers no user command; it is driven by .open().
    "SmiteshP/nvim-navbuddy",
    keys = {
      { "<leader>ln", function() require("nvim-navbuddy").open() end, desc = "LSP | NavBuddy" },
    },
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    opts = { lsp = { auto_attach = true } },
  },
}

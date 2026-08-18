-- Single source of truth for the LSP servers this config manages.
--
-- Consumed by:
--   plugins.lsp.configs.mason      -> ensure_installed
--   plugins.lsp.configs.lspconfig  -> vim.lsp.enable()
--
-- Per-server overrides live in plugins/lsp/settings/<name>.lua and are merged
-- on top of nvim-lspconfig's shipped defaults through vim.lsp.config().
return {
  "lua_ls",
  "cssls",
  "html",
  "ts_ls",
  "pyright",
  "bashls",
  "jsonls",
  "yamlls",
  "clangd",
  "gopls",
  "marksman",
  "tailwindcss",
  "sqlls",
  "jdtls",
}

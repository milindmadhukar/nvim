local servers = {
  "sumneko_lua",
  "cssls",
  "html",
  "tsserver",
  "pyright",
  "bashls",
  "jsonls",
  "yamlls",
  "clangd",
  "gopls",
  "marksman",
  "tailwindcss",
  "sqlls",
}

local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
  vim.notify("Mason not found", "error")
  return
end

local mason_lsp_ok, mason_lsp_config = pcall(require, "mason-lspconfig")
if not mason_lsp_ok then
  vim.notify("Mason LSP Config not found", "error")
  return
end

mason_lsp_config.setup {
  ensure_installed = servers,
  automatic_installation = true,
}

local handlers_ok, lsp_handlers = pcall(require, "user.lsp.handlers")
if not handlers_ok then
  vim.notify("Lsp Handlers not found", "error")
  return
end

mason.setup {
  ui = {
    border = "rounded",
    keymaps = {
      toggle_package_expand = "<CR>",
      install_package = "i",
      update_package = "u",
      check_package_version = "c",
      update_all_packages = "U",
      check_outdated_packages = "C",
      uninstall_package = "X",
      cancel_installation = "<C-c>",
      apply_language_filter = "<C-f>",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,

  github = {
    -- The template URL to use when downloading assets from GitHub.
    -- The placeholders are the following (in order):
    -- 1. The repository (e.g. "rust-lang/rust-analyzer")
    -- 2. The release version (e.g. "v0.3.0")
    -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
    download_url_template = "https://github.com/%s/releases/download/%s/%s",
  },
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  vim.notify("LSP Config not found", "error")
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = lsp_handlers.on_attach,
    capabilities = lsp_handlers.capabilities,
  }

  server = vim.split(server, "@")[1]

  local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
  end

  lspconfig[server].setup(opts)
end

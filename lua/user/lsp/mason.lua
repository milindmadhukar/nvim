local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local mason_lsp_ok, mason_lsp_config = pcall(require, "mason-lspconfig")
if not mason_lsp_ok then
	return
end

local handlers_ok, lsp_handlers = pcall(require, "user.lsp.handlers")
if not handlers_ok then
	return
end

local opts = {
	on_attach = lsp_handlers.on_attach,
	capabilities = lsp_handlers.capabilities,
}

mason.setup({
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
})

mason_lsp_config.setup_handlers({
	-- Automatically invoke lspconfig setup for every installed LSP server
	function(server_name)
		require("lspconfig")[server_name].setup(opts)
	end,

	sumneko_lua = function()
		local lua_opts = vim.tbl_deep_extend("force", require("user.lsp.settings.sumneko_lua"), opts)
		require("lspconfig").sumneko_lua.setup(lua_opts)
	end,

	jsonls = function()
		local json_opts = vim.tbl_deep_extend("force", require("user.lsp.settings.jsonls"), opts)
		require("lspconfig").jsonls.setup(json_opts)
	end,

  pyright = function()
    local pyright_opts = vim.tbl_deep_extend("force", require("user.lsp.settings.pyright"), opts)
    require("lspconfig").pyright.setup(pyright_opts)
  end,
})

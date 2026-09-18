---@type NvPluginSpec
--  NOTE: LSP Configuration
--
--  nvim-lspconfig is now only a *data* repository of server definitions.
--  Registration goes through the native vim.lsp.config() / vim.lsp.enable()
--  API (nvim 0.11+), and per-buffer setup happens in an LspAttach autocmd.
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  -- A dependency rather than a sibling spec: the config below requires
  -- plugins/lsp/settings/{jsonls,yamlls}.lua synchronously, and those call
  -- require "schemastore" at load time.
  dependencies = { "b0o/SchemaStore.nvim" },
  config = function()
    local servers = require "plugins.lsp.servers"

    -- ── Diagnostics ────────────────────────────────────────────────────────
    local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }

    vim.diagnostic.config {
      virtual_text = false,
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = signs.Error,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.HINT] = signs.Hint,
          [vim.diagnostic.severity.INFO] = signs.Info,
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
          [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
          [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        },
      },
    }

    -- ── Shared capabilities ────────────────────────────────────────────────
    -- nvim 0.12 supplies sane defaults; we only layer nvim-cmp's extras on top.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok_cmp then
      capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
    end

    vim.lsp.config("*", { capabilities = capabilities })

    -- ── Per-server overrides ───────────────────────────────────────────────
    -- Each plugins/lsp/settings/<name>.lua returns a vim.lsp.Config table that
    -- is merged over nvim-lspconfig's default definition for that server.
    for _, server in ipairs(servers) do
      local ok, override = pcall(require, "plugins.lsp.settings." .. server)
      if ok and type(override) == "table" then
        vim.lsp.config(server, override)
      end
    end

    -- ── Per-buffer setup ───────────────────────────────────────────────────
    -- Replaces the old on_attach plumbing. LspAttach fires for every client,
    -- including ones started outside this file (nvim-jdtls, rustaceanvim).
    local hl_group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
          return
        end
        local bufnr = ev.buf

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = "LSP | " .. desc })
        end

        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "gr", vim.lsp.buf.references, "References")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")

        -- Highlight other references to the symbol under the cursor.
        if client:supports_method "textDocument/documentHighlight" then
          vim.api.nvim_clear_autocmds { buffer = bufnr, group = hl_group }
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = hl_group,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = hl_group,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- NvChad's base46 theme drives its own semantic-token highlights.
        if client:supports_method "textDocument/semanticTokens" then
          client.server_capabilities.semanticTokensProvider = nil
        end

        if client:supports_method "textDocument/documentSymbol" then
          local ok_navic, navic = pcall(require, "nvim-navic")
          if ok_navic then
            navic.attach(client, bufnr)
          end
        end
      end,
    })

    -- ── Global diagnostic keymaps ──────────────────────────────────────────
    local function dmap(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { silent = true, desc = "Diagnostic | " .. desc })
    end

    dmap("gl", vim.diagnostic.open_float, "Line diagnostics")
    dmap("[d", function()
      vim.diagnostic.jump { count = -1, float = true }
    end, "Previous diagnostic")
    dmap("]d", function()
      vim.diagnostic.jump { count = 1, float = true }
    end, "Next diagnostic")
    dmap("<leader>dl", vim.diagnostic.setloclist, "Diagnostics to loclist")

    vim.keymap.set("n", "<leader>lh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { silent = true, desc = "LSP | Toggle inlay hints" })

    -- servers.lua already excludes jdtls; nvim-jdtls starts it per buffer.
    vim.lsp.enable(servers)
  end,
}

local M = {}
local keymap = vim.keymap.set
local cmp_nvim_lsp = require "cmp_nvim_lsp"

M.capabilities = cmp_nvim_lsp.default_capabilities()

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local buf_keymap = vim.api.nvim_buf_set_keymap
  --[[ keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts) ]]
  buf_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

  -- LspSaga
  -- keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
  -- keymap(bufnr, "n", "gd", "<cmd>Lspsaga preview_definition<CR>", opts
  -- keymap(bufnr, "n", "gl", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
  -- keymap(bufnr, "n", "gr", "<cmd>Lspsaga lsp_finder<CR>", opts)
  -- keymap(bufnr, "n", "gs", "<cmd>Lspsaga signature_help<CR>", opts)
end

-- Highlight symbol under cursor
local function lsp_highlight(client, bufnr)
  if client.supports_method "textDocument/documentHighlight" then
    vim.api.nvim_create_augroup("lsp_document_highlight", {
      clear = false,
    })
    vim.api.nvim_clear_autocmds {
      buffer = bufnr,
      group = "lsp_document_highlight",
    }
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  lsp_highlight(client, bufnr)

  if client.name == "typescript-language-server" then
    client.server_capabilities.document_formatting = false
  end

  if client.name == "sumneko_lua" then
    client.server_capabilities.document_formatting = false
  end

  local illuminate_status_ok, illuminate = pcall(require, "illuminate")
  if not illuminate_status_ok then
    return
  end
  illuminate.on_attach(client)

  local navic_status_ok, navic = pcall(require, "nvim-navic")
  if not navic_status_ok then
    vim.notify("Navic not found", "warn")
    return
  end

  local navbuddy_status_ok, navbuddy = pcall(require, "nvim-navbuddy")
  if not navbuddy_status_ok then
    vim.notify("Navbuddy not found", "warn")
  end

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
    navbuddy.attach(client, bufnr)
  end
end

M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

vim.cmd([[ command! LspToggleAutoFormat execute 'lua require("user.functions").toggle_format_on_save()' ]])

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

return M


-- NOTE: Formatting
--
-- The formatters themselves are installed by mason-tool-installer, declared in
-- plugins/lsp/configs/mason.lua. Keep the two lists in sync.
local prettier = { "prettier" }

local formatters_by_ft = {
  lua = { "stylua" },
  python = { "ruff_format" },
  c = { "clang-format" },
  cpp = { "clang-format" },
  go = { "goimports", "gofumpt" },
  sh = { "shfmt" },
  bash = { "shfmt" },
  yaml = { "yamlfmt" },
  css = prettier,
  graphql = prettier,
  html = prettier,
  json = prettier,
  jsonc = prettier,
  javascript = prettier,
  javascriptreact = prettier,
  less = prettier,
  markdown = prettier,
  scss = prettier,
  typescript = prettier,
  typescriptreact = prettier,
  vue = prettier,
}

return {
  "stevearc/conform.nvim",
  event = "User FilePost",
  cmd = "ConformInfo",
  init = function()
    -- :Format, optionally over a range. Falls back to the LSP when no
    -- formatter is configured for the filetype.
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format { async = true, lsp_format = "fallback", range = range }
    end, { range = true, desc = "Format buffer or range" })
  end,
  opts = {
    formatters_by_ft = formatters_by_ft,
    default_format_opts = { lsp_format = "fallback" },
    -- format_on_save is deliberately off; use :Format or <leader>lf.
  },
}

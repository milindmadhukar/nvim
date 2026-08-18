-- NOTE: Package installer
--
-- The repos moved from williamboman/* to mason-org/* and mason-lspconfig v2
-- dropped `handlers` entirely; servers are registered by
-- plugins/lsp/configs/lspconfig.lua through vim.lsp.config/enable instead.
local servers = require "plugins.lsp.servers"

-- Formatters and linters. mason only installs LSP servers unless asked, which
-- is why conform.nvim previously had almost nothing to run.
local tools = {
  "stylua",
  "ruff",
  "gofumpt",
  "goimports",
  "prettier",
  "yamlfmt",
  "shfmt",
  "clang-format",
}

return {
  "mason-org/mason.nvim",
  event = "User FilePost",
  init = function()
    vim.keymap.set("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Mason | Installer", silent = true })
  end,
  cmd = {
    "Mason",
    "MasonInstall",
    "MasonUpdate",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonLog",
    "MasonToolsInstall",
    "MasonToolsUpdate",
  },
  dependencies = {
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        ensure_installed = servers,
        -- lspconfig.lua owns enabling, so mason must not also auto-enable:
        -- it would start jdtls behind nvim-jdtls's back.
        automatic_enable = false,
      },
    },
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = {
        ensure_installed = tools,
        run_on_start = true,
        auto_update = false,
      },
    },
  },
  opts = {
    registries = {
      "github:nvim-java/mason-registry",
      "github:mason-org/mason-registry",
    },
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
  },
}

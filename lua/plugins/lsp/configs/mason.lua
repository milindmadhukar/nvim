-- NOTE: Package installer
--
-- The repos moved from williamboman/* to mason-org/*, and mason-lspconfig v2
-- dropped `handlers`; servers are registered by plugins/lsp/configs/lspconfig.lua
-- through vim.lsp.config/enable instead.
--
-- These are three sibling specs rather than one with dependencies: lazy loads a
-- plugin's dependencies *before* the plugin itself, so making mason-lspconfig a
-- dependency of mason.nvim ran mason-lspconfig.setup() first and produced
-- "mason.nvim has not been set up". Depending the other way round fixes the order.
local servers = require "plugins.lsp.servers"

-- mason only installs LSP servers unless asked, which is why conform.nvim
-- previously had almost nothing to run.
local tools = {
  "stylua",
  "ruff",
  "gofumpt",
  "goimports",
  "prettier",
  "yamlfmt",
  "shfmt",
  "clang-format",
  -- jdtls is driven by nvim-jdtls, not lspconfig, so mason-lspconfig rejects it
  -- in ensure_installed. Install the package here instead.
  "jdtls",
}

return {
  {
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
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "User FilePost",
    opts = {
      ensure_installed = servers,
      -- lspconfig.lua owns enabling via vim.lsp.enable().
      automatic_enable = false,
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    event = "User FilePost",
    opts = {
      ensure_installed = tools,
      run_on_start = true,
      auto_update = false,
    },
  },
}

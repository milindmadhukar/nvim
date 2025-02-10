-- NOTE: Package installer
local servers = {
  "lua_ls",
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
  "jdtls",
  -- "lemminx",
  -- "r_language_server",
  -- "rust_analyzer",
  -- "svelte",
}

local M = {
  "williamboman/mason.nvim",
  event = "User FilePost",
  init = function()
    vim.keymap.set("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Mason | Installer", silent = true })
  end,
  cmd = {
    "Mason",
    "MasonInstall",
    "MasonInstallAll",
    "MasonUpdate",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonLog",
  },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local mason = require "mason"
      -- local path = require "mason-core.path"
      local mason_lspconfig = require "mason-lspconfig"
      local on_attach = require("plugins.lsp.opts").on_attach
      local on_init = require("plugins.lsp.opts").on_init
      local capabilities = require("plugins.lsp.opts").capabilities

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
        -- install_root_dir = path.concat { vim.fn.stdpath "config", "/lua/custom/mason" },
      }

      mason_lspconfig.setup {
        ensure_installed = servers,
        automatic_installation = true,
      }

      mason_lspconfig.setup_handlers {
        -- Automatically configure the LSP installed
        function(server_name)
          local opts = {
            on_attach = on_attach,
            on_init = on_init,
            capabilities = capabilities,
          }

          local require_ok, server = pcall(require, "plugins.lsp.settings." .. server_name)
          if require_ok then
            opts = vim.tbl_deep_extend("force", server, opts)
          end

          require("lspconfig")[server_name].setup(opts)
        end,
      }
    end,
  },
  opts = {
    registries = {
      "github:nvim-java/mason-registry",
      "github:mason-org/mason-registry",
    },
  },
}

return M

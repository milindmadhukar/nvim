-- NOTE: Package installer
local servers = {
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

local M = {
  "williamboman/mason.nvim",
  event = "User FilePost", -- Only load Mason after a file is opened
  init = function()
    -- Keymap to open Mason UI
    vim.keymap.set("n", "<leader>lm", "<cmd>Mason<cr>", { desc = "Mason | Installer", silent = true })
  end,
  -- Define Mason commands for lazy loading
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
      local mason_lspconfig = require "mason-lspconfig"
      local lspconfig = require "lspconfig"

      -- Load your global LSP options from plugins.lsp.opts
      -- This file should define your default on_attach, on_init, and capabilities
      local lsp_opts = require("plugins.lsp.opts")
      local global_on_attach = lsp_opts.on_attach
      local global_on_init = lsp_opts.on_init
      local global_capabilities = lsp_opts.capabilities

      -- Configure Mason itself
      mason.setup {
        ui = {
          border = "rounded", -- Use rounded borders for Mason UI
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
      }

      -- Configure mason-lspconfig to ensure specified servers are installed
      mason_lspconfig.setup {
        ensure_installed = servers,
        automatic_installation = true,
        handlers = {
          function(server_name)
            local opts = {
              on_attach = global_on_attach,
              on_init = global_on_init,
              capabilities = global_capabilities,
            }

            local require_ok, server_specific_settings = pcall(require, "plugins.lsp.settings." .. server_name)

            if require_ok then
              local original_server_on_attach = server_specific_settings.on_attach
              server_specific_settings.on_attach = function(client, bufnr)
                if global_on_attach then
                  global_on_attach(client, bufnr)
                end
                if original_server_on_attach then
                  original_server_on_attach(client, bufnr)
                end
              end
              
               -- IMPORTANT: deep_extend will overwrite opts.on_attach if present in settings. 
               -- But since we redefined server_specific_settings.on_attach above to INCLUDE global_on_attach,
               -- it should be safe.
               
              opts = vim.tbl_deep_extend("force", opts, server_specific_settings)
            end

            lspconfig[server_name].setup(opts)
          end,
        }
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

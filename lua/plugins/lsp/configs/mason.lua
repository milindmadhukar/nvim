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
  -- "lemminx", -- Uncomment and configure if needed
  -- "r_language_server", -- Uncomment and configure if needed
  -- "rust_analyzer", -- Uncomment and configure if needed
  -- "svelte", -- Uncomment and configure if needed
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
        -- If you want to specify a custom install directory for Mason, uncomment this:
        -- install_root_dir = require("mason-core.path").concat { vim.fn.stdpath "config", "/lua/custom/mason" },
      }

      -- Configure mason-lspconfig to ensure specified servers are installed
      mason_lspconfig.setup {
        ensure_installed = servers,         -- List of servers to ensure are installed
        automatic_installation = true,      -- Automatically install missing servers
        -- The 'handlers' table is the new way to configure LSP servers
        handlers = {
          -- This function will be called for each LSP server that Mason installs and sets up.
          -- It receives the server_name (e.g., "lua_ls", "pyright").
          function(server_name)
            -- Start with a base set of options, including global on_attach, on_init, and capabilities
            local opts = {
              on_attach = global_on_attach,
              on_init = global_on_init,
              capabilities = global_capabilities,
            }

            -- Attempt to load server-specific settings from 'plugins.lsp.settings.<server_name>'
            -- For example, for 'lua_ls', it will try to load 'plugins.lsp.settings.lua_ls'
            local require_ok, server_specific_settings = pcall(require, "plugins.lsp.settings." .. server_name)

            if require_ok then
              -- If server-specific settings exist, we need to merge them carefully.

              -- Handle on_attach: Compose global and server-specific on_attach functions.
              -- The global on_attach will run first, then the server-specific one.
              local original_server_on_attach = server_specific_settings.on_attach
              server_specific_settings.on_attach = function(client, bufnr)
                if global_on_attach then
                  global_on_attach(client, bufnr)
                end
                if original_server_on_attach then
                  original_server_on_attach(client, bufnr)
                end
              end

              -- Handle on_init: Compose global and server-specific on_init functions.
              local original_server_on_init = server_specific_settings.on_init
              server_specific_settings.on_init = function(client, initialize_params)
                if global_on_init then
                  global_on_init(client, initialize_params)
                end
                if original_server_on_init then
                  original_server_on_init(client, initialize_params)
                end
              end

              -- Merge other settings (like `settings` table, `root_dir`, etc.)
              -- `vim.tbl_deep_extend("force", ...)` performs a deep merge,
              -- with the second table's values taking precedence.
              opts = vim.tbl_deep_extend("force", opts, server_specific_settings)
            end

            -- Finally, set up the LSP server using lspconfig with the combined options
            lspconfig[server_name].setup(opts)
          end,
        }
      }
    end,
  },
  opts = {
    -- Define additional Mason registries if you use them (e.g., for Java LSPs)
    registries = {
      "github:nvim-java/mason-registry",
      "github:mason-org/mason-registry",
    },
  },
}

return M


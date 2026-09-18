-- NOTE: Rust
--
-- rustaceanvim is the successor to the archived rust-tools.nvim. It is a
-- *filetype plugin*: it starts and owns the rust-analyzer client itself, which
-- is why `rust_analyzer` is deliberately absent from plugins/lsp/servers.lua.
-- Adding it there would attach a second client to every rust buffer.
--
-- It has no setup(). Configuration goes through `vim.g.rustaceanvim`, so the
-- spec below uses `init` -- which lazy runs at startup, long before the first
-- rust buffer reads the table -- rather than `opts`, which lazy would collect
-- and then silently drop.
--
-- Capabilities need no plumbing here: plugins/lsp/configs/lspconfig.lua calls
-- `vim.lsp.config("*", { capabilities = ... })`, and rustaceanvim resolves
-- `vim.lsp.config["rust-analyzer"]` (which Neovim merges from "*") over its own
-- server table. nvim-cmp's capabilities arrive that way, and because the merge
-- is a deep one rustaceanvim's own `experimental` block -- hoverActions,
-- codeActionGroup, ssr -- survives intact. Setting `server.capabilities` here
-- is what would actually break it.
--
-- rust-analyzer itself comes from rustup (`rustup component add rust-analyzer`),
-- which rustaceanvim prefers over a mason-installed copy. Nothing rust-related
-- belongs in mason.lua.
--
-- Keymaps are NOT here. Every <leader> binding in this config lives in
-- plugins/whichkey.lua; the Rust and Cargo.toml ones are the `rust_mappings`
-- and `crates_mappings` specs there, registered per-buffer from an LspAttach
-- autocmd so they only exist in the buffers they apply to.
--
-- Debugging is not wired up: codelldb is absent from mason.lua's `tools` by
-- choice. To enable it, add "codelldb" there and bind :RustLsp debuggables --
-- rustaceanvim auto-detects a mason codelldb and registers
-- dap.configurations.rust itself, so plugins/dap.lua needs no rust adapter.

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    ft = "rust",
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          -- Match the rounded borders used by diagnostics, which-key and mason.
          float_win_config = { border = "rounded" },
          -- Fall back to vim.ui.select (snacks) when rust-analyzer returns no
          -- grouped actions, so <leader>ca always does something.
          code_actions = { ui_select_fallback = true },
        },
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                buildScripts = { enable = true },
                loadOutDirsFromCheck = true,
              },
              -- rustaceanvim's `tools.enable_clippy` already turns on clippy
              -- with `--no-deps` when `check` is nil; spelling it out skips that
              -- branch, which is why --no-deps is repeated here.
              --
              -- Do NOT add --all-targets to extraArgs. rust-analyzer already
              -- passes it (check.allTargets defaults to true), and clippy hard
              -- errors on the duplicate -- "the argument '--all-targets' cannot
              -- be used multiple times". The check then exits 1 with no JSON on
              -- stdout, so rust-analyzer publishes no diagnostics at all and the
              -- buffer looks clean even when the crate does not compile. Set
              -- check.allTargets = false to stop linting tests and benches.
              checkOnSave = true,
              check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
              -- Toggled by <leader>lh (plugins/lsp/configs/lspconfig.lua).
              inlayHints = {
                bindingModeHints = { enable = true },
                closureReturnTypeHints = { enable = "always" },
                lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
                parameterHints = { enable = true },
                typeHints = { enable = true },
              },
              files = {
                exclude = { ".direnv", ".git", ".jj", "node_modules", "target", ".venv" },
                -- Client-side watching; the server-side watcher can hang on
                -- "Roots Scanned" (rust-analyzer#12613).
                watcher = "client",
              },
            },
          },
        },
      }
    end,
  },

  {
    -- Versions, features and dependency info inline in Cargo.toml.
    --
    -- `lsp.enabled` runs crates.nvim as an in-process language server, so its
    -- completions reach nvim-cmp through cmp-nvim-lsp and its hover answers K,
    -- with no cmp source to register and nothing to keep in sync. It is also
    -- what gives whichkey.lua's LspAttach autocmd a "crates.nvim" client to
    -- hang the Cargo.toml mappings off.
    "saecki/crates.nvim",
    tag = "stable",
    event = "BufRead Cargo.toml",
    opts = {
      completion = {
        crates = { enabled = true },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
}

local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
}

local setup = {
  preset = "classic",
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = true, suggestions = 20 },
    presets = {
      operators = false,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
  win = { border = "rounded" },
}

-- NOTE: every entry below is checked against a command that actually exists.
-- Removed in the 2026 pass: the Packer group (lazy.nvim is the manager),
-- TroubleToggle (trouble v3 uses :Trouble), lspsaga, Neorg, ChatGPT/Copilot,
-- bufferline, barbecue, true-zen, session-lens, Telescope media_files,
-- toggleterm's _*_TOGGLE globals, and everything calling `user.functions`
-- (that module never existed; the real one is `utils`).
local mappings = {
  { "<leader>;", "<cmd>Nvdash<CR>", desc = "Dashboard" },
  { "<leader>F", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find Text" },
  { "<leader>H", "<cmd>nohlsearch<CR>", desc = "Clear highlighting" },
  { "<leader>L", "<cmd>Lazy<cr>", desc = "Lazy Menu" },
  { "<leader>N", "<cmd>lua Snacks.notifier.show_history()<cr>", desc = "Notifications" },
  { "<leader>O", "<cmd>Oil<cr>", desc = "Oil" },
  { "<leader>S", "<cmd>lua require('utils.screenshot').generate_carbon_screenshot()<cr>", desc = "Take screenshot" },
  { "<leader>T", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble Diagnostics" },
  { "<leader>c", "<cmd>lua require('utils').handle_buffer_close()<cr>", desc = "Close Buffer" },
  { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
  { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find files" },
  { "<leader>m", "<cmd>lua MiniMap.toggle()<CR>", desc = "Toggle Minimap" },
  { "<leader>q", "<cmd>lua require('utils.quit').confirm()<CR>", desc = "Quit" },
  { "<leader>w", "<cmd>w!<CR>", desc = "Save" },
  { "<leader>x", "<cmd>lua require('utils').sourcefile()<CR>", desc = "Source File" },
  { "<leader>z", "<cmd>lua Snacks.zen()<cr>", desc = "Toggle Zen Mode" },
  { "<leader>Z", "<cmd>lua Snacks.zen.zoom()<cr>", desc = "Zoom this window" },
  -- Scratch buffers are per-cwd and per-filetype, and persist between sessions.
  { "<leader>.", "<cmd>lua Snacks.scratch()<cr>", desc = "Scratch buffer" },
  { "<leader>,", "<cmd>lua Snacks.scratch.select()<cr>", desc = "Scratch buffers" },

  -- Rust / Cargo. Only the group label is global; the keys under it are
  -- buffer-local and are registered by the LspAttach autocmd in M.config --
  -- rust_mappings for .rs buffers, crates_mappings for Cargo.toml.
  { "<leader>C", group = "Rust / Cargo" },

  -- Buffers (NvChad tabufline; bufferline.nvim was removed)
  { "<leader>b", group = "Buffers" },
  { "<leader>bb", "<cmd>lua require('nvchad.tabufline').prev()<cr>", desc = "Previous" },
  { "<leader>bn", "<cmd>lua require('nvchad.tabufline').next()<cr>", desc = "Next" },
  { "<leader>bc", "<cmd>lua require('nvchad.tabufline').closeAllBufs(false)<cr>", desc = "Close others" },
  { "<leader>bf", "<cmd>Telescope buffers<cr>", desc = "Find" },
  { "<leader>bs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search lines" },

  -- Debug
  { "<leader>d", group = "Debug" },
  { "<leader>dB", "<cmd>lua require'dap'.step_back()<cr>", desc = "Step Back" },
  { "<leader>dC", "<cmd>lua require'dap'.run_to_cursor()<cr>", desc = "Run To Cursor" },
  { "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", desc = "Step Out" },
  { "<leader>dS", "<cmd>lua require'dap'.session()<cr>", desc = "Get Session" },
  { "<leader>dU", "<cmd>lua require'dapui'.toggle()<cr>", desc = "Toggle DAP UI" },
  { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
  { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue" },
  { "<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>", desc = "Disconnect" },
  { "<leader>dg", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Golang Debug Test" },
  { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "Step Into" },
  { "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "Step Over" },
  { "<leader>dp", "<cmd>lua require'dap'.pause()<cr>", desc = "Pause" },
  { "<leader>dq", "<cmd>lua require'dap'.close()<cr>", desc = "Quit" },
  { "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc = "Toggle Repl" },
  { "<leader>ds", "<cmd>lua require'dap'.continue()<cr>", desc = "Start" },

  -- Git
  { "<leader>g", group = "Git" },
  -- <leader>gg (lazygit) is defined by plugins/toggleterm.lua
  { "<leader>gB", "<cmd>lua Snacks.gitbrowse()<cr>", desc = "Open in browser", mode = { "n", "v" } },
  { "<leader>gG", "<cmd>Git<CR>", desc = "Fugitive Git" },
  { "<leader>gL", "<cmd>lua Snacks.git.blame_line()<cr>", desc = "Blame line (full commit)" },
  { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
  { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
  { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
  { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff" },
  { "<leader>gj", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
  { "<leader>gk", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },
  { "<leader>gl", "<cmd>Gitsigns blame_line<cr>", desc = "Blame" },
  { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file" },
  { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
  { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
  { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
  { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage Hunk" },

  -- Harpoon
  { "<leader>h", group = "Harpoon" },
  { "<leader>h1", '<cmd>lua require("harpoon"):list():select(1)<CR>', desc = "Go to file 1" },
  { "<leader>h2", '<cmd>lua require("harpoon"):list():select(2)<CR>', desc = "Go to file 2" },
  { "<leader>h3", '<cmd>lua require("harpoon"):list():select(3)<CR>', desc = "Go to file 3" },
  { "<leader>h4", '<cmd>lua require("harpoon"):list():select(4)<CR>', desc = "Go to file 4" },
  { "<leader>h5", '<cmd>lua require("harpoon"):list():select(5)<CR>', desc = "Go to file 5" },
  { "<leader>h6", '<cmd>lua require("harpoon"):list():select(6)<CR>', desc = "Go to file 6" },
  { "<leader>h7", '<cmd>lua require("harpoon"):list():select(7)<CR>', desc = "Go to file 7" },
  { "<leader>h8", '<cmd>lua require("harpoon"):list():select(8)<CR>', desc = "Go to file 8" },
  { "<leader>h9", '<cmd>lua require("harpoon"):list():select(9)<CR>', desc = "Go to file 9" },
  { "<leader>h0", '<cmd>lua require("harpoon"):list():select(10)<CR>', desc = "Go to file 10" },
  { "<leader>ha", "<cmd>lua require('harpoon'):list():add()<CR>", desc = "Add file" },
  {
    "<leader>hm",
    "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>",
    desc = "Menu Toggle",
  },
  { "<leader>hn", '<cmd>lua require("harpoon"):list():prev()<CR>', desc = "Prev Harpoon Mark" },
  { "<leader>hp", '<cmd>lua require("harpoon"):list():next()<CR>', desc = "Next Harpoon Mark" },

  -- LSP
  { "<leader>l", group = "LSP" },
  { "<leader>lF", "<cmd>lua Snacks.rename.rename_file()<cr>", desc = "Rename file (updates imports)" },
  { "<leader>lR", "<cmd>lsp restart<cr>", desc = "Restart LSP" },
  { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
  { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code Action" },
  { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
  { "<leader>lf", "<cmd>Format<cr>", desc = "Format" },
  { "<leader>lh", "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>", desc = "Inlay Hints" },
  { "<leader>li", "<cmd>checkhealth vim.lsp<cr>", desc = "LSP Info" },
  {
    "<leader>lj",
    "<cmd>lua vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })<cr>",
    desc = "Next Error",
  },
  {
    "<leader>lk",
    "<cmd>lua vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })<cr>",
    desc = "Prev Error",
  },
  { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
  { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" },
  { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
  { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
  { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
  { "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },

  -- Neovide (works from terminal nvim too -- it launches the GUI)
  { "<leader>n", group = "Neovide" },
  { "<leader>nn", "<cmd>lua require('utils.gui').here()<cr>", desc = "New window (cwd)" },
  { "<leader>nf", "<cmd>lua require('utils.gui').file()<cr>", desc = "New window with this file" },
  { "<leader>np", "<cmd>lua require('utils.gui').project()<cr>", desc = "New window at project root" },
  { "<leader>nd", "<cmd>lua require('utils.gui').prompt()<cr>", desc = "New window in directory..." },
  { "<leader>nr", "<cmd>lua require('utils.gui').recent()<cr>", desc = "New window in recent project (telescope)" },

  -- Other
  { "<leader>o", group = "Other" },
  { "<leader>oc", "<cmd>CodiNew javascript<cr>", desc = "Javascript Scratchpad" },
  { "<leader>og", "<cmd>Glow<cr>", desc = "Markdown preview (Glow)" },
  { "<leader>oh", "<cmd>Huefy<cr>", desc = "Colour picker (minty Huefy)" },
  { "<leader>ok", "<cmd>ShowkeysToggle<cr>", desc = "Toggle keycast (showkeys)" },
  { "<leader>os", "<cmd>Shades<cr>", desc = "Colour shades (minty Shades)" },
  { "<leader>ot", "<cmd>lua require('base46').toggle_transparency()<cr>", desc = "Toggle Transparency" },
  { "<leader>oy", "<cmd>Typr<cr>", desc = "Typing test (typr)" },
  { "<leader>oY", "<cmd>TyprStats<cr>", desc = "Typing stats (typr)" },

  -- Refactoring (normal mode).
  -- The API changed upstream: `refactoring.refactor("Extract Function")` and
  -- `refactoring.debug.*` are gone, replaced by named functions on the main
  -- module and a `refactoring.debug` submodule.
  { "<leader>R", group = "Refactoring" },
  { "<leader>Rc", "<cmd>lua require('refactoring.debug').cleanup({})<CR>", desc = "Cleanup debug prints" },
  { "<leader>Rp", "<cmd>lua require('refactoring.debug').print_loc({below = true})<CR>", desc = "Print location" },
  { "<leader>Rv", "<cmd>lua require('refactoring.debug').print_var({})<CR>", desc = "Print variable" },
  { "<leader>Rr", "<cmd>lua require('refactoring').select_refactor()<CR>", desc = "Select refactor" },

  -- Search
  { "<leader>s", group = "Search" },
  { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
  { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
  { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
  { "<leader>sb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
  {
    "<leader>sc",
    '<cmd>lua require("nvchad.themes").open({ icon = "", style = "compact" })<cr>',
    desc = "Colorscheme",
  },
  { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
  { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
  { "<leader>sl", "<cmd>Telescope resume<cr>", desc = "Last Search" },
  { "<leader>sp", "<cmd>Telescope projects<cr>", desc = "Projects" },
  { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Recent File" },

  -- Trouble & Terminal
  { "<leader>t", group = "Trouble & Terminal" },
  -- Split terminals (nvchad.term, via utils/term.lua). th/tv are the keys this
  -- config gave the horizontal and vertical terminals back when toggleterm
  -- provided them (`ToggleTerm direction=horizontal` / `=vertical`); same keys,
  -- same names, different engine. The float and the tool terminals -- tf, tt,
  -- tg, td, tH -- are lazy keys on plugins/floaterm.lua.
  { "<leader>th", "<cmd>lua require('utils.term').toggle('bottom')<cr>", desc = "Horizontal" },
  { "<leader>tv", "<cmd>lua require('utils.term').toggle('right')<cr>", desc = "Vertical" },
  { "<leader>tD", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document Diagnostics" },
  { "<leader>tT", "<cmd>TodoTelescope<cr>", desc = "Todo list" },
  { "<leader>tl", "<cmd>Trouble loclist toggle<cr>", desc = "Loclist" },
  { "<leader>tq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
  { "<leader>tr", "<cmd>Trouble lsp_references toggle<cr>", desc = "References" },
  { "<leader>ts", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
  { "<leader>tw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics" },
}

local vmappings = {
  mode = { "v" },
  { "<leader>S", "<cmd>lua require('utils.screenshot').generate_carbon_screenshot()<cr>", desc = "Take screenshot" },
  { "<leader>r", group = "Refactoring" },
  { "<leader>rV", "<cmd>lua require('refactoring.debug').print_var({})<CR>", desc = "Print Debug Variable" },
  { "<leader>re", "<cmd>Refactor extract_func<CR>", desc = "Extract Function" },
  { "<leader>rf", "<cmd>Refactor extract_func_to_file<CR>", desc = "Extract function to file" },
  { "<leader>ri", "<cmd>Refactor inline_var<CR>", desc = "Inline Variable" },
  { "<leader>rr", "<cmd>lua require('refactoring').select_refactor()<CR>", desc = "Select Refactor" },
  { "<leader>rv", "<cmd>Refactor extract_var<CR>", desc = "Extract Variable" },
}

-- Buffer-local mappings. These are not part of `mappings` above because they
-- must only exist in the buffers they apply to, and because :RustLsp is only
-- defined once rust-analyzer has attached. Both sets are registered from the
-- LspAttach autocmd in M.config, keyed on the client name. The plugins
-- themselves are configured in plugins/rust.lua.

-- Rust source files (rustaceanvim).
local rust_mappings = {
  { "<leader>CD", "<cmd>RustLsp openDocs<cr>", desc = "Open docs.rs" },
  { "<leader>CE", "<cmd>RustLsp renderDiagnostic<cr>", desc = "Render diagnostic (cargo-style)" },
  { "<leader>CL", "<cmd>RustAnalyzer restart<cr>", desc = "Restart rust-analyzer" },
  { "<leader>Cr", "<cmd>RustLsp! runnables<cr>", desc = "Rerun last runnable" },
  { "<leader>CT", "<cmd>RustLsp! testables<cr>", desc = "Rerun last testable" },
  { "<leader>Ce", "<cmd>RustLsp explainError<cr>", desc = "Explain error" },
  { "<leader>Cj", "<cmd>RustLsp joinLines<cr>", desc = "Join lines" },
  { "<leader>Ck", "<cmd>RustLsp flyCheck<cr>", desc = "Fly check" },
  { "<leader>Cm", "<cmd>RustLsp expandMacro<cr>", desc = "Expand macro" },
  { "<leader>Co", "<cmd>RustLsp openCargo<cr>", desc = "Open Cargo.toml" },
  { "<leader>Cp", "<cmd>RustLsp parentModule<cr>", desc = "Parent module" },
  { "<leader>CR", "<cmd>RustLsp runnables<cr>", desc = "Runnables" },
  { "<leader>Cs", "<cmd>RustLsp ssr<cr>", desc = "Structural search/replace", mode = { "n", "v" } },
  { "<leader>Ct", "<cmd>RustLsp testables<cr>", desc = "Testables" },
  { "<leader>Cy", "<cmd>RustLsp syntaxTree<cr>", desc = "Syntax tree" },
}

-- Overrides of the global LSP keys: rust-analyzer groups its code actions and
-- attaches hover actions, and vim.lsp.buf.* flattens both away. Kept separate
-- from rust_mappings because these are only registered once rust-analyzer has
-- attached -- :RustLsp does not exist before that, and hijacking K in a rust
-- buffer with no client would turn a harmless no-op into an error.
local rust_lsp_overrides = {
  { "K", "<cmd>RustLsp hover actions<cr>", desc = "Hover actions" },
  { "<leader>ca", "<cmd>RustLsp codeAction<cr>", desc = "Code Action (grouped)" },
  { "<leader>la", "<cmd>RustLsp codeAction<cr>", desc = "Code Action (grouped)" },
}

-- Cargo.toml (crates.nvim). K is left alone on purpose: crates.nvim runs an
-- in-process language server that answers hover, so the global K already gives
-- the crate popup.
local crates_mappings = {
  { "<leader>CA", "<cmd>lua require('crates').upgrade_all_crates()<cr>", desc = "Upgrade all" },
  { "<leader>CC", "<cmd>lua require('crates').open_crates_io()<cr>", desc = "Open crates.io" },
  { "<leader>CD", "<cmd>lua require('crates').open_documentation()<cr>", desc = "Open docs.rs" },
  { "<leader>CH", "<cmd>lua require('crates').open_homepage()<cr>", desc = "Open homepage" },
  { "<leader>CR", "<cmd>lua require('crates').open_repository()<cr>", desc = "Open repository" },
  { "<leader>CU", "<cmd>lua require('crates').upgrade_crate()<cr>", desc = "Upgrade crate" },
  { "<leader>CU", "<cmd>lua require('crates').upgrade_crates()<cr>", desc = "Upgrade selected crates", mode = "v" },
  { "<leader>Ca", "<cmd>lua require('crates').update_all_crates()<cr>", desc = "Update all" },
  { "<leader>Cd", "<cmd>lua require('crates').show_dependencies_popup()<cr>", desc = "Dependencies" },
  { "<leader>Cf", "<cmd>lua require('crates').show_features_popup()<cr>", desc = "Features" },
  { "<leader>Cr", "<cmd>lua require('crates').reload()<cr>", desc = "Reload" },
  { "<leader>Ct", "<cmd>lua require('crates').toggle()<cr>", desc = "Toggle extra info" },
  { "<leader>Cu", "<cmd>lua require('crates').update_crate()<cr>", desc = "Update crate" },
  { "<leader>Cu", "<cmd>lua require('crates').update_crates()<cr>", desc = "Update selected crates", mode = "v" },
  { "<leader>Cv", "<cmd>lua require('crates').show_versions_popup()<cr>", desc = "Versions" },
  {
    "<leader>Cx",
    "<cmd>lua require('crates').expand_plain_crate_to_inline_table()<cr>",
    desc = "Expand to inline table",
  },
}

-- Which buffer-local spec belongs to which LSP client.
local by_client = {
  ["rust-analyzer"] = rust_lsp_overrides,
  ["crates.nvim"] = crates_mappings,
}

function M.config()
  local wk = require "which-key"
  wk.setup(setup)
  wk.add(mappings)
  wk.add(vmappings)

  -- `buffer` is an inheriting spec field, so the whole nested list lands as
  -- buffer-local mappings.
  --
  -- The deepcopy is load-bearing: which-key's parser writes the resolved buffer
  -- number back onto the spec entries it is handed (mappings.lua, `if
  -- mapping.buffer == 0 or mapping.buffer == true`). Passing the shared table
  -- would bake the *first* buffer's number into it, and every later buffer
  -- would silently re-register against that one instead of itself.
  --
  -- vim.schedule is load-bearing too: plugins/lsp/configs/lspconfig.lua binds K
  -- and <leader>ca from its own LspAttach autocmd, and after which-key has
  -- loaded wk.add applies mappings immediately. Deferring by a tick guarantees
  -- the Rust overrides are set last and therefore win.
  local function attach(buf, spec)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) then
        wk.add { buffer = buf, vim.deepcopy(spec) }
      end
    end)
  end

  -- Filetype is the primary trigger, so the group is populated the moment the
  -- buffer exists. LspAttach alone was not enough: rust-analyzer does not
  -- attach to a buffer with no file on disk, which left <leader>C dead on a
  -- newly created .rs file, on :enew + set ft=rust, and on any .rs outside a
  -- cargo project. crates.nvim's functions never needed a client at all.
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user_wk_rust", { clear = true }),
    pattern = "rust",
    callback = function(ev)
      attach(ev.buf, rust_mappings)
    end,
  })

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("user_wk_crates", { clear = true }),
    pattern = "Cargo.toml",
    callback = function(ev)
      attach(ev.buf, crates_mappings)
    end,
  })

  -- Applied on attach so the K / <leader>ca / <leader>la overrides land after
  -- lspconfig.lua's LspAttach handler has bound the generic LSP versions. For
  -- Cargo.toml this re-applies crates_mappings, which is harmless.
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user_wk_lsp_attach", { clear = true }),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local spec = client and by_client[client.name]
      if spec then
        attach(ev.buf, spec)
      end
    end,
  })
end

return M

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
  { "<leader>N", "<cmd>Telescope notify<cr>", desc = "Notifications" },
  { "<leader>O", "<cmd>Oil<cr>", desc = "Oil" },
  { "<leader>S", "<cmd>lua require('utils.screenshot').generate_carbon_screenshot()<cr>", desc = "Take screenshot" },
  { "<leader>T", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble Diagnostics" },
  { "<leader>c", "<cmd>lua require('utils').handle_buffer_close()<cr>", desc = "Close Buffer" },
  { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
  { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find files" },
  { "<leader>m", "<cmd>MinimapToggle<CR>", desc = "Toggle Minimap" },
  { "<leader>q", "<cmd>lua require('utils').smart_quit()<CR>", desc = "Quit" },
  { "<leader>w", "<cmd>w!<CR>", desc = "Save" },
  { "<leader>x", "<cmd>lua require('utils').sourcefile()<CR>", desc = "Source File" },
  { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },

  -- Buffers (NvChad tabufline; bufferline.nvim was removed)
  { "<leader>b", group = "Buffers" },
  { "<leader>bb", "<cmd>lua require('nvchad.tabufline').prev()<cr>", desc = "Previous" },
  { "<leader>bn", "<cmd>lua require('nvchad.tabufline').next()<cr>", desc = "Next" },
  { "<leader>bc", "<cmd>lua require('nvchad.tabufline').closeAllBufs(false)<cr>", desc = "Close others" },
  { "<leader>bf", "<cmd>Telescope buffers<cr>", desc = "Find" },

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
  { "<leader>gG", "<cmd>Git<CR>", desc = "Fugitive Git" },
  { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
  { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
  { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
  { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff" },
  { "<leader>gg", "<cmd>FloatermToggle Lazygit<cr>", desc = "Lazygit" },
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
  { "<leader>ha", "<cmd>lua require('harpoon'):list():add()<CR>", desc = "Add file" },
  { "<leader>hm", "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>", desc = "Menu Toggle" },
  { "<leader>hn", '<cmd>lua require("harpoon"):list():prev()<CR>', desc = "Prev Harpoon Mark" },
  { "<leader>hp", '<cmd>lua require("harpoon"):list():next()<CR>', desc = "Next Harpoon Mark" },

  -- LSP
  { "<leader>l", group = "LSP" },
  { "<leader>lR", "<cmd>LspRestart<cr>", desc = "Restart LSP" },
  { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
  { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code Action" },
  { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
  { "<leader>lf", "<cmd>Format<cr>", desc = "Format" },
  { "<leader>lh", "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>", desc = "Inlay Hints" },
  { "<leader>li", "<cmd>checkhealth vim.lsp<cr>", desc = "LSP Info" },
  { "<leader>lj", "<cmd>lua vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })<cr>", desc = "Next Error" },
  { "<leader>lk", "<cmd>lua vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })<cr>", desc = "Prev Error" },
  { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
  { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" },
  { "<leader>ln", "<cmd>NavBuddy<cr>", desc = "NavBuddy" },
  { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
  { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
  { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
  { "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },

  -- Other
  { "<leader>o", group = "Other" },
  { "<leader>oc", "<cmd>CodiNew javascript<cr>", desc = "Javascript Scratchpad" },
  { "<leader>og", "<cmd>Glow<cr>", desc = "Markdown preview (Glow)" },
  { "<leader>ot", "<cmd>lua require('base46').toggle_transparency()<cr>", desc = "Toggle Transparency" },

  -- Refactoring (normal mode)
  { "<leader>R", group = "Refactoring" },
  { "<leader>Rc", "<cmd>lua require('refactoring').debug.cleanup({})<CR>", desc = "Cleanup" },
  { "<leader>Rp", "<cmd>lua require('refactoring').debug.printf({below = true})<CR>", desc = "Printf" },

  -- Search
  { "<leader>s", group = "Search" },
  { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
  { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
  { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
  { "<leader>sb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
  { "<leader>sc", '<cmd>lua require("nvchad.themes").open({ icon = "", style = "compact" })<cr>', desc = "Colorscheme" },
  { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
  { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
  { "<leader>sl", "<cmd>Telescope resume<cr>", desc = "Last Search" },
  { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Recent File" },

  -- Trouble & Terminal
  { "<leader>t", group = "Trouble & Terminal" },
  { "<leader>tD", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document Diagnostics" },
  { "<leader>tT", "<cmd>TodoTelescope<cr>", desc = "Todo list" },
  { "<leader>td", "<cmd>FloatermToggle Lazydocker<cr>", desc = "Lazy Docker" },
  { "<leader>tg", "<cmd>FloatermToggle Lazygit<cr>", desc = "Lazy Git" },
  { "<leader>tH", "<cmd>FloatermToggle Htop<cr>", desc = "Htop" },
  { "<leader>tl", "<cmd>Trouble loclist toggle<cr>", desc = "Loclist" },
  { "<leader>tn", "<cmd>FloatermToggle Node<cr>", desc = "Node" },
  { "<leader>tp", "<cmd>FloatermToggle Python<cr>", desc = "Python" },
  { "<leader>tq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
  { "<leader>tr", "<cmd>Trouble lsp_references toggle<cr>", desc = "References" },
  { "<leader>tt", "<cmd>FloatermToggle<cr>", desc = "Terminal" },
  { "<leader>ts", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
  { "<leader>tw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics" },
}

local vmappings = {
  mode = { "v" },
  { "<leader>S", "<cmd>lua require('utils.screenshot').generate_carbon_screenshot()<cr>", desc = "Take screenshot" },
  { "<leader>r", group = "Refactoring" },
  { "<leader>rV", "<cmd>lua require('refactoring').debug.print_var({})<CR>", desc = "Print Debug Variables" },
  { "<leader>re", "<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>", desc = "Extract Function" },
  { "<leader>rf", "<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>", desc = "Extract function to file" },
  { "<leader>ri", "<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>", desc = "Inline Variable" },
  { "<leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", desc = "Telescope Refactor" },
  { "<leader>rv", "<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>", desc = "Extract Variable" },
}

function M.config()
  local wk = require "which-key"
  wk.setup(setup)
  wk.add(mappings)
  wk.add(vmappings)
end

return M

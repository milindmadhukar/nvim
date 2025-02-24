local M = {
  "folke/which-key.nvim",
}

local setup = {
  plugins = {
    marks = true,       -- shows a list of your marks on ' and `
    registers = true,   -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = false,   -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true,      -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true,      -- default bindings on <c-w>
      nav = true,          -- misc bindings to work with windows
      z = true,            -- bindings for folds, spelling and others prefixed with z
      g = true,            -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3,                    -- spacing between columns
    align = "left",                 -- align columns left, center or right
  },
  show_help = true,                 -- show help message on the command line when the popup is visible
}

local opts = {
  mode = "n",     -- NORMAL mode
  prefix = "<leader>",
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true,  -- use `nowait` when creating keymaps
}

local mappings = {
  { "<leader>;", "<cmd>Nvdash<CR>", desc = "Dashboard", nowait = true, remap = false },
  { "<leader>C", group = "Copilot and ChatGPT", nowait = true, remap = false },
  { "<leader>CA", "<cmd>ChatGPTActAs<cr>", desc = "ChatGPT Act As", nowait = true, remap = false },
  { "<leader>CC", "<cmd>ChatGPTCompleteCode<cr>", desc = "ChatGPT Complete Code", nowait = true, remap = false },
  { "<leader>CS", "<cmd>Copilot status<cr>", desc = "Status", nowait = true, remap = false },
  { "<leader>Cc", "<cmd>ChatGPT<cr>", desc = "ChatGPT", nowait = true, remap = false },
  { "<leader>Cd", "<cmd>Copilot toggle<cr>", desc = "Toggle Copilot", nowait = true, remap = false },
  { "<leader>Cp", "<cmd>Copilot panel<cr>", desc = "Show Panel", nowait = true, remap = false },
  { "<leader>Ct", "<cmd>Copilot suggestion toggle_auto_trigger<cr>", desc = "Toggle Copilot Sugesstions", nowait = true, remap = false },
  { "<leader>F", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find Text", nowait = true, remap = false },
  { "<leader>H", "<cmd>nohlsearch<CR>", desc = "Clear highlighting", nowait = true, remap = false },
  { "<leader>L", "<cmd>Lazy<cr>", desc = "Lazy Menu", nowait = true, remap = false },
  { "<leader>N", "<cmd>lua require('telescope').extensions.notify.notify()<cr>", desc = "Notifications", nowait = true, remap = false },
  { "<leader>O", "<cmd>Oil<cr>", desc = "Oil", nowait = true, remap = false },
  { "<leader>P", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects", nowait = true, remap = false },
  { "<leader>R", group = "Refactoring", nowait = true, remap = false },
  { "<leader>Rc", "<cmd>lua require('refactoring').debug.cleanup({})<CR>", desc = "Cleanup", nowait = true, remap = false },
  { "<leader>Rp", "<cmd>lua require('refactoring').debug.printf({below = true})<CR>", desc = "Printf", nowait = true, remap = false },
  { "<leader>S", "<cmd>lua require('user.screenshot').generate_carbon_screenshot()<cr>", desc = "Take screenshot", nowait = true, remap = false },
  { "<leader>T", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Trouble Diagnostics", nowait = true, remap = false },
  { "<leader>Za", "<cmd>TZAtaraxis<cr>", desc = "Toggle ataraxis mode", nowait = true, remap = false },
  { "<leader>Zf", "<cmd>TZFocus<cr>", desc = "Toggle focus mode", nowait = true, remap = false },
  { "<leader>Zm", "<cmd>TZMinimalist<cr>", desc = "Toggle minimalist mode", nowait = true, remap = false },
  { "<leader>Zz", "<cmd>TZNarrow<cr>", desc = "Toggle narrow mode", nowait = true, remap = false },
  { "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code Action", nowait = true, remap = false },
  { "<leader>b", group = "Buffers", nowait = true, remap = false },
  { "<leader>bD", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by directory", nowait = true, remap = false },
  { "<leader>bL", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by language", nowait = true, remap = false },
  { "<leader>bb", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous", nowait = true, remap = false },
  { "<leader>be", "<cmd>BufferLinePickClose<cr>", desc = "Pick which buffer to close", nowait = true, remap = false },
  { "<leader>bf", "<cmd>Telescope buffers<cr>", desc = "Find", nowait = true, remap = false },
  { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left", nowait = true, remap = false },
  { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump", nowait = true, remap = false },
  { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close all to the right", nowait = true, remap = false },
  { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next", nowait = true, remap = false },
  { "<leader>c", "<cmd>lua require('utils').handle_buffer_close()<cr>", desc = "Close Buffer", nowait = true, remap = false },
  { "<leader>d", group = "Debug", nowait = true, remap = false },
  { "<leader>dB", "<cmd>lua require'dap'.step_back()<cr>", desc = "Step Back", nowait = true, remap = false },
  { "<leader>dC", "<cmd>lua require'dap'.run_to_cursor()<cr>", desc = "Run To Cursor", nowait = true, remap = false },
  { "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", desc = "Step Out", nowait = true, remap = false },
  { "<leader>dS", "<cmd>lua require'dap'.session()<cr>", desc = "Get Session", nowait = true, remap = false },
  { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle Breakpoint", nowait = true, remap = false },
  { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue", nowait = true, remap = false },
  { "<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>", desc = "Disconnect", nowait = true, remap = false },
  { "<leader>dg", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Golang Debug Test", nowait = true, remap = false },
  { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "Step Into", nowait = true, remap = false },
  { "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "Step Over", nowait = true, remap = false },
  { "<leader>dp", "<cmd>lua require'dap'.pause()<cr>", desc = "Pause", nowait = true, remap = false },
  { "<leader>dq", "<cmd>lua require'dap'.close()<cr>", desc = "Quit", nowait = true, remap = false },
  { "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc = "Toggle Repl", nowait = true, remap = false },
  { "<leader>ds", "<cmd>lua require'dap'.continue()<cr>", desc = "Start", nowait = true, remap = false },
  { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer", nowait = true, remap = false },
  { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find files", nowait = true, remap = false },
  { "<leader>g", group = "Git", nowait = true, remap = false },
  { "<leader>gG", "<cmd>Git<CR>", desc = "Fugititve Git", nowait = true, remap = false },
  { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer", nowait = true, remap = false },
  { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch", nowait = true, remap = false },
  { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit", nowait = true, remap = false },
  { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff", nowait = true, remap = false },
  { "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "Lazygit", nowait = true, remap = false },
  { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk", nowait = true, remap = false },
  { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk", nowait = true, remap = false },
  { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame", nowait = true, remap = false },
  { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file", nowait = true, remap = false },
  { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk", nowait = true, remap = false },
  { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk", nowait = true, remap = false },
  { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk", nowait = true, remap = false },
  { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk", nowait = true, remap = false },
  { "<leader>h", group = "Harpoon", nowait = true, remap = false },
  { "<leader>h0", '<cmd>lua require("harpoon"):list():select(0)<CR>', desc = "Go to file 0", nowait = true, remap = false },
  { "<leader>h1", '<cmd>lua require("harpoon"):list():select(1)<CR>', desc = "Go to file 1", nowait = true, remap = false },
  { "<leader>h2", '<cmd>lua require("harpoon"):list():select(2)<CR>', desc = "Go to file 2", nowait = true, remap = false },
  { "<leader>h3", '<cmd>lua require("harpoon"):list():select(3)<CR>', desc = "Go to file 3", nowait = true, remap = false },
  { "<leader>h4", '<cmd>lua require("harpoon"):list():select(4)<CR>', desc = "Go to file 4", nowait = true, remap = false },
  { "<leader>h5", '<cmd>lua require("harpoon"):list():select(5)<CR>', desc = "Go to file 5", nowait = true, remap = false },
  { "<leader>h6", '<cmd>lua require("harpoon"):list():select(6)<CR>', desc = "Go to file 6", nowait = true, remap = false },
  { "<leader>h7", '<cmd>lua require("harpoon"):list():select(7)<CR>', desc = "Go to file 7", nowait = true, remap = false },
  { "<leader>h8", '<cmd>lua require("harpoon"):list():select(8)<CR>', desc = "Go to file 8", nowait = true, remap = false },
  { "<leader>h9", '<cmd>lua require("harpoon"):list():select(9)<CR>', desc = "Go to file 9", nowait = true, remap = false },
  { "<leader>ha", "<cmd>lua require('harpoon'):list():add()<CR>", desc = "Add file", nowait = true, remap = false },
  { "<leader>hm", "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>", desc = "Menu Toggle", nowait = true, remap = false },
  { "<leader>hn", '<cmd>lua require("harpoon"):list():prev()<CR>', desc = "Next Harpoon Mark", nowait = true, remap = false },
  { "<leader>hp", '<cmd>lua require("harpoon"):list():next()<CR>', desc = "Prev Harpoon Mark", nowait = true, remap = false },
  { "<leader>ht", "<cmd>Telescope harpoon marks<CR>", desc = "Telescope Marks", nowait = true, remap = false },
  { "<leader>l", group = "LSP", nowait = true, remap = false },
  { "<leader>lF", "<cmd>LspToggleAutoFormat<CR>", desc = "Toggle Auto Format", nowait = true, remap = false },
  { "<leader>lR", "<cmd>LspRestart<cr>", desc = "Restart LSP", nowait = true, remap = false },
  { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols", nowait = true, remap = false },
  { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code Action", nowait = true, remap = false },
  { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics", nowait = true, remap = false },
  { "<leader>lf", "<cmd>Format<cr>", desc = "Format", nowait = true, remap = false },
  { "<leader>lh", "<cmd>lua vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())<cr>", desc = "Inlay Hints", nowait = true, remap = false },
  { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info", nowait = true, remap = false },
  { "<leader>lj", "<cmd>lua require('lspsaga.diagnostic').goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>", desc = "Prev Diagnostic", nowait = true, remap = false },
  { "<leader>lk", "<cmd>lua require('lspsaga.diagnostic').goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>", desc = "Previous Diagnostic", nowait = true, remap = false },
  { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action", nowait = true, remap = false },
  { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason", nowait = true, remap = false },
  { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix", nowait = true, remap = false },
  { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename", nowait = true, remap = false },
  { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols", nowait = true, remap = false },
  { "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics", nowait = true, remap = false },
  { "<leader>m", "<cmd>MinimapToggle<CR>", desc = "Toggle Minimap", nowait = true, remap = false },
  { "<leader>n", group = "Neorg", nowait = true, remap = false },
  { "<leader>nc", "<cmd>Neorg toggle-concealer<cr>", desc = "Toggle Concealer (icons)", nowait = true, remap = false },
  { "<leader>ne", "<cmd>lua require('user.functions').export_neorg_to_md()<cr>", desc = "Export file to markdown", nowait = true, remap = false },
  { "<leader>nf", "<cmd>Telescope neorg find_norg_files<cr>", desc = "Find Norg Files", nowait = true, remap = false },
  { "<leader>ng", "<cmd>Neorg workspace twig<cr>", desc = "Open TWiG workspace", nowait = true, remap = false },
  { "<leader>ni", "<cmd>Neorg index<cr>", desc = "Index files", nowait = true, remap = false },
  { "<leader>nj", "<cmd>Neorg journal today<cr>", desc = "Open today's journal", nowait = true, remap = false },
  { "<leader>no", "<cmd>Neorg workspace notes<cr>", desc = "Open Notes workspace", nowait = true, remap = false },
  { "<leader>ns", "<cmd>Neorg sync-parsers<cr>", desc = "Sync Neorg Parsers", nowait = true, remap = false },
  { "<leader>o", group = "Other", nowait = true, remap = false },
  { "<leader>ob", "<cmd>lua require('barbecue.ui').toggle()<cr>", desc = "Toggle Barbecue", nowait = true, remap = false },
  { "<leader>oc", "<cmd>CodiNew javascript<cr>", desc = "Javascript Scratchpad", nowait = true, remap = false },
  { "<leader>ot", "<cmd>lua require('base46').toggle_transparency()<cr>", desc = "Toggle Background Tranparency", nowait = true, remap = false },
  { "<leader>p", group = "Packer", nowait = true, remap = false },
  { "<leader>pS", "<cmd>PackerStatus<cr>", desc = "Status", nowait = true, remap = false },
  { "<leader>pc", "<cmd>PackerCompile<cr>", desc = "Compile", nowait = true, remap = false },
  { "<leader>pi", "<cmd>PackerInstall<cr>", desc = "Install", nowait = true, remap = false },
  { "<leader>ps", "<cmd>PackerSync<cr>", desc = "Sync", nowait = true, remap = false },
  { "<leader>pu", "<cmd>PackerUpdate<cr>", desc = "Update", nowait = true, remap = false },
  { "<leader>q", "<cmd>lua require('user.functions').smart_quit()<CR>", desc = "Quit", nowait = true, remap = false },
  { "<leader>r", "<cmd>TermExec cmd='clear && g++ % && ./a.out'<CR>", desc = "Run C++ Program", nowait = true, remap = false },
  { "<leader>s", group = "Search", nowait = true, remap = false },
  { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands", nowait = true, remap = false },
  { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages", nowait = true, remap = false },
  { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers", nowait = true, remap = false },
  { "<leader>sb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch", nowait = true, remap = false },
  { "<leader>sc", "<cmd>lua require('nvchad.themes').open({ icon = \"\", style=\"compact\" })<cr>", desc = "Colorscheme", nowait = true, remap = false },
  { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help", nowait = true, remap = false },
  { "<leader>si", "<cmd>Telescope media_files<cr>", desc = "Media", nowait = true, remap = false },
  { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps", nowait = true, remap = false },
  { "<leader>sl", "<cmd>Telescope resume<cr>", desc = "Last Search", nowait = true, remap = false },
  { "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Recent File", nowait = true, remap = false },
  { "<leader>ss", "<cmd>Telescope session-lens search_session<cr>", desc = "Sessions", nowait = true, remap = false },
  { "<leader>t", group = "Trouble & Terminal", nowait = true, remap = false },
  { "<leader>tD", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document", nowait = true, remap = false },
  { "<leader>tH", "<cmd>lua _HTOP_TOGGLE()<cr>", desc = "Htop", nowait = true, remap = false },
  { "<leader>tT", "<cmd>TodoTelescope<cr>", desc = "Toggle Todo Telescope Menu", nowait = true, remap = false },
  { "<leader>tV", "<cmd>lua _VTOP_TOGGLE()<cr>", desc = "Vtop", nowait = true, remap = false },
  { "<leader>td", "<cmd>lua _LAZYDOCKER_TOGGLE()<cr>", desc = "Lazy Docker", nowait = true, remap = false },
  { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float", nowait = true, remap = false },
  { "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", desc = "Lazy Git", nowait = true, remap = false },
  { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal", nowait = true, remap = false },
  { "<leader>tl", "<cmd>TroubleToggle loclist<cr>", desc = "Loclist", nowait = true, remap = false },
  { "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", desc = "Node", nowait = true, remap = false },
  { "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", desc = "Python", nowait = true, remap = false },
  { "<leader>tq", "<cmd>TroubleToggle quickfix<cr>", desc = "Show Quickfix(s)", nowait = true, remap = false },
  { "<leader>tr", "<cmd>TroubleToggle lsp_references<cr>", desc = "References", nowait = true, remap = false },
  { "<leader>tt", "<cmd>ToggleTermToggleAll<CR>", desc = "Toggle All Terminals", nowait = true, remap = false },
  { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical", nowait = true, remap = false },
  { "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace", nowait = true, remap = false },
  { "<leader>w", "<cmd>w!<CR>", desc = "Save", nowait = true, remap = false },
  { "<leader>x", "<cmd>lua require('user.functions').sourcefile()<CR>", desc = "Source File", nowait = true, remap = false },
  { "<leader>z", "<cmd>TZMinimalist<cr>", desc = "Toggle narrow mode", nowait = true, remap = false },
  {
    mode = { "n", "v" },
    { "<leader>Ca", "<cmd>ChatGPTRun add_tests<CR>",                 desc = "Add Tests",                 nowait = true, remap = false },
    { "<leader>Ce", "<cmd>ChatGPTEditWithInstruction<CR>",           desc = "Edit with instruction",     nowait = true, remap = false },
    { "<leader>Cg", "<cmd>ChatGPTRun grammar_correction<CR>",        desc = "Grammar Correction",        nowait = true, remap = false },
    { "<leader>Ck", "<cmd>ChatGPTRun keywords<CR>",                  desc = "Keywords",                  nowait = true, remap = false },
    { "<leader>Cl", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis", nowait = true, remap = false },
    { "<leader>Co", "<cmd>ChatGPTRun optimize_code<CR>",             desc = "Optimize Code",             nowait = true, remap = false },
    { "<leader>Cs", "<cmd>ChatGPTRun summarize<CR>",                 desc = "Summarize",                 nowait = true, remap = false },
    { "<leader>Cx", "<cmd>ChatGPTRun explain_code<CR>",              desc = "Explain Code",              nowait = true, remap = false },
  },
}

local vmappings = {
  {
    mode = { "v" },
    { "<leader>/",  "<Plug>(comment_toggle_linewise_visual)",                                        desc = "Comment",                  nowait = true, remap = false },
    { "<leader>S",  "<cmd>lua require('user.screenshot').generate_carbon_screenshot()<cr>",          desc = "Take screenshot",          nowait = true, remap = false },
    { "<leader>r",  group = "Refactoring",                                                           nowait = true,                     remap = false },
    { "<leader>rV", "<cmd>lua require('refactoring').debug.print_var({})<CR>",                       desc = "Print Debug Variables",    nowait = true, remap = false },
    { "<leader>re", "<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>",         desc = "Extract Function",         nowait = true, remap = false },
    { "<leader>rf", "<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>", desc = "Extract function to file", nowait = true, remap = false },
    { "<leader>ri", "<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>",          desc = "Inline Variable",          nowait = true, remap = false },
    { "<leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",     desc = "Telescope Refactor",       nowait = true, remap = false },
    { "<leader>rv", "<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>",         desc = "Extract Variable",         nowait = true, remap = false },
    { "<leader>z",  "<cmd>'<,'>TZNarrow<cr>",                                                        desc = "Toggle narrow mode",       nowait = true, remap = false },
  },
}

function M.config()
  local wk = require("which-key")
  wk.add(mappings)
  wk.add(vmappings)
end

return M

-- NOTE: NvChad Related Options

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "tokyodark",
  integrations = {
    "notify",
    "dap",
    "trouble",
  },
}


-- BUG: Fix buttons
M.nvdash = {
  load_on_startup = true,
  header = require("core.headers").mg,
  buttons = {
    { txt="  Find File", keys="f", cmd="Telescope find_files" },
    { txt="󰈚  Recent Files", keys="r", cmd="Telescope oldfiles" },
    { txt="  Find text", keys="t", cmd="Telescope live_grep" },
    { txt="  Find Project", keys="p", cmd="Telescope projects" },
    { txt="  New file", keys="e", cmd="ene <BAR> startinsert" },
    { txt="  Configuration", keys="c", cmd="e ~/.config/nvim/init.lua" },
    { txt="  Quit Neovim", keys="q", cmd="qa" },
  },
}


M.ui = {
  theme = "tokyodark",
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  },

  tabufline = {
    enabled = true,
    lazyload = false,
    order = { "treeOffset", "buffers", "tabs", "btns" },
    modules = {
      blank = function()
        return "%#Normal#" .. "%=" -- empty space
      end,
      -- custom_btns = function()
      --   return " %#Normal#%@v:lua.ClickGit@  %#Normal#%@v:lua.RunCode@  %#Normal#%@v:lua.ClickSplit@  "
      -- end,
    },
  },
}

M.cheatsheet = { theme = "grid" } -- simple/grid

M.treesitter = {
  ensure_installed = {
    "javascript",
    "typescript",
    "go",
    "python",
    "c",
    "cpp",
    "dockerfile",
    "rust",
    "lua",
    "cmake",
    "markdown",
    "bash",
    "html",
    "css",
    "java",
  },

  highlight = { enable = true },
  indent = { enable = true },
  autotag = {
    enable = true,
  },
}

M.lsp = { signature = false }

return M

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


M.ui = {
  theme = "tokyodark",
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  },

  tabufline = {
    enabled = true,
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


  -- BUG: Fix buttons
  nvdash = {
    load_on_startup = true,
    header = require("core.headers").mg,
    buttons = {
      { "  Find File", "f", "Telescope find_files" },
      { "󰈚  Recent Files", "r", "Telescope oldfiles" },
      { "  Find text", "t", "Telescope live_grep" },
      { "  Find Project", "p", "Telescope projects" },
      { "  New file", "e", "ene <BAR> startinsert" },
      { "  Configuration", "c", "e ~/.config/nvim/init.lua" },
      { "  Quit Neovim", "q", "qa" },
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

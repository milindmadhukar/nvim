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

M.mason = {
  cmd = true,
  -- Use names from mason.nvim
  -- For example, if you want to install "tsserver" you should use "typescript-language-server" in the list below
  automatic_installation = true,
  pkgs = {
    -- Lua
    "lua-language-server",
    "vim-language-server",
    "stylua",

    -- Web Development
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "tailwindcss-language-server",
    -- "eslint-lsp",
    -- "deno",
    -- "vue-language-server",
    -- "emmet_language_server",

    -- C/C++
    "clangd",
    -- "clang-format",

    -- Json
    "json-lsp",

    -- Yaml
    "yaml-language-server",

    -- Markdown
    "marksman",

    -- Bash
    "bash-language-server",

    -- Python
    "basedpyright",

    -- Go
    "gopls",

    -- SQL
    "sqls",

    -- Java
    -- "jdtls",
  },
}

M.lsp = { signature = false }

return M

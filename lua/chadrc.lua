-- NOTE: NvChad Related Options

---@type ChadrcConfig
local M = {}

-- base46 no longer picks the colours you see -- lua/plugins/colorschemes.lua
-- loads the catppuccin plugin on top of it. What is left to base46 is NvChad's
-- own UI: the tabufline, nvdash and the cheatsheet. Its bundled "catppuccin"
-- theme predates the palette Catppuccin settled on (a #1E1D2D background, an
-- older green and mauve), so those bits would sit a shade off the rest of the
-- editor. `changed_themes` pins it to the current official Mocha palette, and
-- the two halves match.
--
-- Values below are Mocha as published (catppuccin/palettes/mocha.lua); the
-- handful base46 needs that Mocha does not define -- intermediate background
-- steps and a couple of tints -- are interpolated from it and marked.
local mocha = {
  base_30 = {
    white = "#cdd6f4", -- text
    darker_black = "#181825", -- mantle
    black = "#1e1e2e", -- base, i.e. the editor background
    black2 = "#252537", -- derived
    one_bg = "#2a2b3c", -- derived
    one_bg2 = "#313244", -- surface0
    one_bg3 = "#3a3c4e", -- derived
    grey = "#45475a", -- surface1
    grey_fg = "#585b70", -- surface2
    grey_fg2 = "#6c7086", -- overlay0
    light_grey = "#7f849c", -- overlay1
    red = "#f38ba8",
    baby_pink = "#eba0ac", -- maroon
    pink = "#f5c2e7",
    line = "#313244", -- surface0, for vertsplit and friends
    green = "#a6e3a1",
    vibrant_green = "#b5e8b0", -- derived
    nord_blue = "#74c7ec", -- sapphire
    blue = "#89b4fa",
    yellow = "#f9e2af",
    sun = "#fbebc3", -- derived
    purple = "#cba6f7", -- mauve
    dark_purple = "#b48ae8", -- derived
    teal = "#94e2d5",
    orange = "#fab387", -- peach
    cyan = "#89dceb", -- sky
    statusline_bg = "#11111b", -- crust
    lightbg = "#2c2d3f", -- derived
    pmenu_bg = "#a6e3a1", -- green
    folder_bg = "#89b4fa", -- blue
    lavender = "#b4befe",
  },

  base_16 = {
    base00 = "#1e1e2e", -- base
    base01 = "#252537", -- derived
    base02 = "#313244", -- surface0
    base03 = "#45475a", -- surface1
    base04 = "#585b70", -- surface2
    base05 = "#bac2de", -- subtext1
    base06 = "#c4cce6", -- derived
    base07 = "#cdd6f4", -- text
    base08 = "#f38ba8", -- red
    base09 = "#fab387", -- peach
    base0A = "#f9e2af", -- yellow
    base0B = "#a6e3a1", -- green
    base0C = "#89dceb", -- sky
    base0D = "#89b4fa", -- blue
    base0E = "#cba6f7", -- mauve
    base0F = "#f2cdcd", -- flamingo
  },
}

M.base46 = {
  theme = "catppuccin",
  changed_themes = { catppuccin = mocha },
  integrations = {
    "notify",
    "dap",
    "trouble",
  },
}

-- nvdash runs each `cmd` as a literal `:` command string, so these have to be
-- real commands -- a function value is silently concatenated and breaks the
-- button. "Find Project" pointed at `Telescope projects`, an extension that no
-- plugin in this config ever provided; plugins/project.lua now supplies it.
M.nvdash = {
  -- Deliberately false: core/autocommands.lua opens nvdash on startup instead.
  -- NvChad's own hook (ui/lua/nvchad/au.lua:5-14) races against anything that
  -- disposes of the startup scratch buffer and throws "Invalid buffer id".
  load_on_startup = false,
  header = require("core.headers").mg,
  buttons = {
    { txt = "  Find File", keys = "f", cmd = "Telescope find_files" },
    { txt = "󰈚  Recent Files", keys = "r", cmd = "Telescope oldfiles" },
    { txt = "  Find text", keys = "t", cmd = "Telescope live_grep" },
    { txt = "  Find Project", keys = "p", cmd = "Telescope projects" },
    { txt = "  New file", keys = "e", cmd = "ene <BAR> startinsert" },
    -- Resolved at load time rather than hardcoding ~/.config/nvim, which is a
    -- stow symlink into the dotfiles repo and not where the file really lives.
    { txt = "  Configuration", keys = "c", cmd = "edit " .. vim.fn.stdpath "config" .. "/init.lua" },
    -- Through :Quit so a stray `q` on the dashboard asks first, like every
    -- other way out of the editor does (see utils/quit.lua).
    { txt = "  Quit Neovim", keys = "q", cmd = "Quit qall" },
  },
}

M.ui = {
  -- NOTE: `theme` used to be repeated here. NvChad v2.5 only ever reads
  -- M.base46.theme, so this copy was dead config.
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

-- NOTE: treesitter config lives in lua/plugins/treesitter.lua.
-- NvChad v2.5 never reads a chadrc treesitter key, so it was dead config here.

M.lsp = { signature = false }

return M

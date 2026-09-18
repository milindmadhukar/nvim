return {
  defaults = { lazy = true },
  install = { colorscheme = { "nvchad" } },

  -- Plugins being worked on locally are loaded from ~/Code/<name> instead of
  -- being cloned into lazy's plugin dir. A spec opts in with `dev = true`
  -- (plugins/floaterm.lua), or automatically if its owner matches `patterns`.
  -- `fallback` means a missing checkout still gets fetched from GitHub rather
  -- than breaking startup.
  dev = {
    path = "~/Code",
    patterns = { "milindmadhukar" },
    fallback = true,
  },

  -- No plugin here needs luarocks; without this lazy reports a health ERROR
  -- about the missing hererocks Lua 5.1 install.
  rocks = { enabled = false },

  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
}

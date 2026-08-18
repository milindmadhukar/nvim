-- NOTE: Terminals
--
-- toggleterm.nvim has had no commits since 2025-03. floaterm is NvZone's
-- (NvChad's) terminal manager and fits the rest of this config's stack.
return {
  "nvzone/floaterm",
  dependencies = { "nvzone/volt" },
  cmd = "FloatermToggle",
  keys = {
    { [[<C-\>]], "<cmd>FloatermToggle<cr>", mode = { "n", "t" }, desc = "Toggle terminal" },
  },
  opts = {
    border = true,
    size = { h = 70, w = 80 },
    -- Named terminals, replacing the old _LAZYGIT_TOGGLE-style globals.
    terminals = {
      { name = "Terminal" },
      { name = "Lazygit", cmd = "lazygit" },
      { name = "Lazydocker", cmd = "lazydocker" },
      { name = "Node", cmd = "node" },
      { name = "Python", cmd = "python3" },
      { name = "Htop", cmd = "htop" },
    },
  },
}

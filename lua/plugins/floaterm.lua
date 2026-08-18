-- NOTE: Terminals
--
-- toggleterm.nvim has had no commits since 2025-03. floaterm is NvZone's
-- (NvChad's) terminal manager and fits the rest of this config's stack.

-- :FloatermToggle takes no arguments, so extra terminals are opened on demand
-- through the API instead. The default set stays at two; this reuses a
-- terminal of the same name if one already exists rather than stacking dupes.
local function term(name, cmd)
  return function()
    local state = require "floaterm.state"

    if not (state.win and vim.api.nvim_win_is_valid(state.win)) then
      require("floaterm").toggle()
    end

    for _, t in ipairs(state.terminals or {}) do
      if t.name == name then
        require("floaterm.utils").switch_buf(t.buf)
        return
      end
    end

    require("floaterm.api").new_term { name = name, cmd = cmd }
  end
end

return {
  "nvzone/floaterm",
  dependencies = { "nvzone/volt" },
  cmd = "FloatermToggle",
  keys = {
    { [[<C-\>]], "<cmd>FloatermToggle<cr>", mode = { "n", "t" }, desc = "Toggle terminal" },
    { "<leader>tt", "<cmd>FloatermToggle<cr>", desc = "Terminal" },
    { "<leader>gg", term("Lazygit", "lazygit"), desc = "Lazygit" },
    { "<leader>tg", term("Lazygit", "lazygit"), desc = "Lazygit" },
    { "<leader>td", term("Lazydocker", "lazydocker"), desc = "Lazydocker" },
    { "<leader>tH", term("Htop", "htop"), desc = "Htop" },
  },
  opts = {
    border = true,
    -- Percentages of the editor, not columns/rows. The default 60/70 leaves a
    -- cramped window; this keeps a visible float margin while staying usable.
    size = { h = 90, w = 92 },
    terminals = {
      { name = "claude", cmd = "claude" },
      { name = "terminal" },
    },
  },
}

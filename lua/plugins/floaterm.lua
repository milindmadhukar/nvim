-- NOTE: Terminals
--
-- toggleterm.nvim has had no commits since 2025-03. floaterm is NvZone's
-- (NvChad's) terminal manager and fits the rest of this config's stack.
--
-- This points at the fork in ~/Code/floaterm rather than nvzone/floaterm:
-- `dev = true` makes lazy load the plugin straight out of that working tree
-- (path configured in core/lazy.lua), so edits there are what Neovim runs.
-- `:Lazy reload floaterm` picks up changes without a restart -- see the
-- `deactivate` hook below, which lazy calls first to tear the UI down.
--
-- To go back to upstream: drop `dev = true` and put the repo back to
-- "nvzone/floaterm".

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
  "milindmadhukar/floaterm",
  dev = true,
  -- lazy manages dev plugins with git like any other, and this working tree is
  -- where the changes are being made -- pinning keeps `:Lazy update`/`sync`
  -- from checking out over the top of them.
  pin = true,
  dependencies = { "nvzone/volt" },
  cmd = "FloatermToggle",
  keys = {
    { [[<C-\>]], "<cmd>FloatermToggle<cr>", mode = { "n", "t" }, desc = "Toggle terminal" },
    { "<leader>tt", "<cmd>FloatermToggle<cr>", desc = "Terminal" },
    -- "Float" was this config's name for the floating terminal under
    -- toggleterm; kept so the old muscle memory still lands somewhere.
    { "<leader>tf", "<cmd>FloatermToggle<cr>", desc = "Float" },
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
    -- The top bar showed the terminal name plus a scrollback byte count and a
    -- creation timestamp. Turning it off buys back two rows of terminal, and
    -- the sidebar already shows the name.
    bar = { enabled = false },
    -- No `name` on these on purpose: an unnamed terminal labels itself from
    -- whatever process is running in it (kitty-tab style), so the first shows
    -- "claude" from its own command and the second shows whatever you run.
    -- Setting `name` pins the label permanently -- which is what the Lazygit /
    -- Lazydocker / Htop terminals above deliberately do.
    terminals = {
      { cmd = "claude" },
    },
  },

  -- Called by lazy on `:Lazy reload floaterm`, before the plugin's lua modules
  -- are dropped from package.loaded. Without this the floats from the old
  -- version are left on screen with no state module behind them.
  deactivate = function()
    local ok, state = pcall(require, "floaterm.state")
    if not ok then
      return
    end

    pcall(function()
      require("floaterm.utils").close_timers()
    end)

    for _, win in ipairs { state.win, state.barwin, state.sidewin } do
      if win and vim.api.nvim_win_is_valid(win) then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end

    local bufs = { state.sidebuf, state.barbuf }
    for _, t in ipairs(state.terminals or {}) do
      bufs[#bufs + 1] = t.buf
    end

    for _, buf in ipairs(bufs) do
      if buf and vim.api.nvim_buf_is_valid(buf) then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end
  end,
}

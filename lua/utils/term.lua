-- NOTE: Split terminals
--
-- nvterm was archived when NvChad v2.5 folded it into the UI plugin as
-- `nvchad.term` (lazy/ui/lua/nvchad/term). It is the same terminal manager --
-- toggleable, id-addressed terminals with base46 colours -- so nothing needs
-- to be installed for this; plugins/init.lua keeps the old standalone plugin
-- disabled.
--
-- floaterm (plugins/floaterm.lua) owns the floats and the tool terminals
-- (lazygit, lazydocker, htop). This covers the two split positions instead:
-- one along the bottom and one down the right.

local M = {}

-- `bo sp` / `bo vsp` rather than plain `sp` / `vsp`: botright anchors the
-- terminal to the edge of the editor no matter which window is focused, so it
-- spans the full width (bottom) or full height (right). Plain splits would cut
-- up whichever window happened to be current. Both spellings are known to
-- nvchad.term's size table, so `M.term.sizes` in chadrc still applies.
local positions = {
  bottom = { pos = "bo sp", id = "term_bottom" },
  right = { pos = "bo vsp", id = "term_right" },
}

-- nvchad.term tracks its terminals in a global and only drops an entry when
-- TermClose fires. A buffer wiped some other way -- `:bwipeout` on the
-- terminal window, a session plugin cleaning up -- leaves a stale entry behind,
-- and toggling that id hands a dead buffer number to nvim_win_set_buf. Prune
-- before every toggle so the id is recreated instead.
local function prune()
  local terms = vim.g.nvchad_terms
  if not terms then
    return
  end

  local kept, dropped = {}, false
  for id, opts in pairs(terms) do
    if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
      kept[id] = opts
    else
      dropped = true
    end
  end

  if dropped then
    vim.g.nvchad_terms = kept
  end
end

local function spec(where)
  local p = positions[where]
  if not p then
    error("utils.term: unknown position " .. tostring(where))
  end
  return p
end

-- Toggle the terminal for a position: opens it, or hides the window if it is
-- already on screen. The buffer and its job survive being hidden, so toggling
-- back returns to the same shell.
function M.toggle(where)
  local p = spec(where)
  prune()
  require("nvchad.term").toggle { pos = p.pos, id = p.id }
end

-- An extra terminal in the same position, with a fresh buffer each time. No
-- id, so it is not toggleable -- close it like any other window.
function M.new(where, cmd)
  local p = spec(where)
  require("nvchad.term").new { pos = p.pos, cmd = cmd }
end

-- Send a command to a dedicated runner terminal, re-running it on each call.
-- Handy for a build/test loop bound to a key.
function M.run(cmd, where)
  local p = spec(where or "bottom")
  require("nvchad.term").runner { pos = p.pos, id = p.id .. "_runner", cmd = cmd }
end

return M

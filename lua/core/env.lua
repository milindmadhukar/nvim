-- NOTE: The environment terminals and jobs inherit
--
-- $EDITOR is exported from ~/.zshrc, and only an *interactive* zsh reads that
-- file. Neither shell in the chain that ends at a terminal buffer is one:
--
--  * Neovide is started by the compositor, so there is no login shell above it
--    at all -- `/proc/<neovide>/environ` has no $EDITOR in it, and neither does
--    the `nvim --embed` it hosts, nor anything either of them spawns.
--  * floaterm's command terminals run as `zsh -c "<cmd>; zsh"`, and `-c` skips
--    .zshrc as well. Even a Neovim that *did* have $EDITOR would not help the
--    plain `:terminal` case any more than this one.
--
-- So every tool that shells out to an editor falls back to its built-in
-- default: Claude Code's <C-g> opens nano, git (no core.editor here) drops to
-- vi. Setting it here fixes all of them at once, because `vim.env` *is* this
-- process's environment -- terminal buffers and jobs are given a copy of it,
-- and utils/gui.lua hands the same copy to the Neovide windows it spawns.
--
-- `v:progpath` rather than a bare "nvim": it is the absolute path of the
-- running binary, so it does not depend on the $PATH of whichever shell ends
-- up running it.

for _, name in ipairs { "EDITOR", "VISUAL" } do
  -- An inherited value wins: a shell that exported one meant it.
  if (vim.env[name] or "") == "" then
    vim.env[name] = vim.v.progpath
  end
end

local M = {
  "lewis6991/gitsigns.nvim",
  enabled = true,
  -- No `event` here on purpose. `event = "BufEnter"` used to sit alongside the
  -- init hook below and fired first on every buffer, git repo or not, which
  -- made the git-detection hook dead code and put ~11ms of gitsigns on the
  -- startup path. The hook alone loads it -- scheduled, so off that path --
  -- and only inside a repo.
  cmd = "Gitsigns",
  init = function()
    -- load gitsigns only when a git file is opened
    vim.api.nvim_create_autocmd({ "BufRead" }, {
      group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
      callback = function()
        vim.fn.system("git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse")
        if vim.v.shell_error == 0 then
          vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
          vim.schedule(function()
            require("lazy").load({ plugins = { "gitsigns.nvim" } })
          end)
        end
      end,
    })
  end,
}

-- NOTE: the keymaps used to live here too, in a `wk.add` inside `config`, AND
-- in plugins/whichkey.lua -- the same nine `<leader>g` keys registered twice,
-- with the two copies already drifting (this one still called the deprecated
-- `next_hunk`/`prev_hunk`). whichkey.lua is now the single home for them: its
-- versions go through `<cmd>Gitsigns ...<cr>`, and `cmd = "Gitsigns"` above
-- means that lazy-loads the plugin just as well as a `require` would.

M.config = function()
  require("gitsigns").setup({
    signs = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    -- Staged hunks get their own signs. Worth knowing this also makes the
    -- stage key a stage/unstage *toggle*: stage_hunk retries with
    -- `staged = true` when the hunk under the cursor is already staged
    -- (actions.lua:318), so <leader>gs on a staged hunk unstages it.
    signs_staged_enable = true,
    signcolumn = true,
    numhl = false,
    linehl = false,

    -- Intra-line highlighting. On a one-character change this shows the
    -- character rather than a whole line marked "changed", which removes the
    -- need to open a diff for most change hunks. Requires
    -- `diff_opts.internal = true`, which is the default.
    word_diff = true,

    -- `diff_opts` is deep-extended, so this adds linematch without dropping
    -- the defaults gitsigns derives from 'diffopt'. linematch pairs changed
    -- lines within a hunk instead of emitting a block delete followed by a
    -- block add, so far fewer hunks read as unexplained deletions.
    diff_opts = { linematch = 60 },

    -- Send `:Gitsigns setqflist`/`setloclist` through trouble's window.
    trouble = true,

    -- NOTE: deliberately NOT enabling always-on deleted lines.
    -- `show_deleted` and `toggle_deleted()` are both deprecated upstream
    -- (config.lua:455, actions.lua:241), and persistent virtual lines desync
    -- the visual position of a line from its real number -- which matters
    -- because a delete hunk occupies exactly one line for staging purposes.
    -- The supported surfaces are `preview_hunk_inline()` (<leader>gp) and
    -- `:Gitsigns diff --diff=unified` (<leader>gd).

    watch_gitdir = {
      follow_files = true,
    },
    auto_attach = true,
    attach_to_untracked = true,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 1000,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 200,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  })
end

return M

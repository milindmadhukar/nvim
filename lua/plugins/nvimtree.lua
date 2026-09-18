-- NOTE: File explorer
--
-- This spec used to be pinned to a May-2023 commit (434 commits behind master),
-- which is what kept the dead options below from erroring. Unpinning meant
-- fixing all of them; see |nvim-tree-legacy| for upstream's rename table.
--
--   nvim-tree.config.nvim_tree_callback   -> removed, use nvim-tree.api directly
--   view.mappings                         -> removed, mappings live in on_attach
--   renderer.root_folder_modifier         -> renderer.root_folder_label
--   update_focused_file.update_cwd        -> update_focused_file.update_root
--
-- The ~50-line hand-copied BEGIN_DEFAULT_ON_ATTACH block is gone too: it was a
-- 2023 snapshot of upstream's defaults that silently rotted as API names moved.
-- api.map.on_attach.default() applies the current set, and only the genuine
-- customisations are spelled out after it.
local M = {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
  -- No nvim-web-devicons dependency on purpose: plugins/essentials.lua makes
  -- mini.icons the single icon provider and mocks that module for it.
}

function M.config()
  local function on_attach(bufnr)
    local api = require "nvim-tree.api"

    -- Every default mapping, always current with the installed version.
    api.map.on_attach.default(bufnr)

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- Custom: vim-style open/close on h/l, plus v for a vertical split.
    vim.keymap.set("n", "l", api.node.open.edit, opts "Open")
    vim.keymap.set("n", "h", api.node.navigate.parent_close, opts "Close Directory")
    vim.keymap.set("n", "v", api.node.open.vertical, opts "Open: Vertical Split")
  end

  require("nvim-tree").setup {
    on_attach = on_attach,
    disable_netrw = true,
    hijack_netrw = true,

    -- Needed by snacks, which decorates vim.ui.select; without it nvim-tree's
    -- prompts render twice.
    select_prompts = true,

    update_focused_file = {
      enable = true,
      update_root = { enable = true },
    },

    renderer = {
      root_folder_label = ":t",
      icons = {
        glyphs = {
          default = "",
          symlink = "",
          folder = {
            arrow_open = "",
            arrow_closed = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
          git = {
            unstaged = "",
            staged = "S",
            unmerged = "",
            renamed = "➜",
            untracked = "U",
            deleted = "",
            ignored = "◌",
          },
        },
      },
    },

    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    },

    view = {
      width = 30,
      side = "left",
    },
  }
end

return M

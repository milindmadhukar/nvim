-- NOTE: NvZone plugins
--
-- These are NvChad's standalone plugins, which moved from the NvChad org to
-- `nvzone` in 2025. All of them sit on nvzone/volt (already a floaterm
-- dependency). Small and stable, but note none has a 2026 commit.
return {
  -- Colour tools: :Huefy (picker) and :Shades (shades of a colour)
  {
    "nvzone/minty",
    dependencies = { "nvzone/volt" },
    cmd = { "Huefy", "Shades" },
  },

  -- Right-click / keyboard context menus
  {
    "nvzone/menu",
    dependencies = { "nvzone/volt" },
    keys = {
      {
        "<C-t>",
        function()
          require("menu").open "default"
        end,
        mode = { "n", "v" },
        desc = "Open context menu",
      },
      {
        "<RightMouse>",
        function()
          -- Move the cursor to the click position first, then open a menu
          -- appropriate to whatever is under it.
          vim.cmd.exec '"normal! \\<RightMouse>"'
          local menu = vim.bo[vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)].ft == "NvimTree"
              and "nvimtree"
            or "default"
          require("menu").open(menu, { mouse = true })
        end,
        mode = { "n", "v" },
        desc = "Open context menu at cursor",
      },
    },
  },

  -- On-screen keycast, for screencasts/demos
  {
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    opts = {
      timeout = 3,
      maxkeys = 5,
      position = "top-right",
    },
  },
}

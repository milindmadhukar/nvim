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

  -- Typing practice: :Typr is the test, :TyprStats the history dashboard.
  {
    "nvzone/typr",
    dependencies = { "nvzone/volt" },
    cmd = { "Typr", "TyprStats" },
    opts = {
      -- "responsive" picks horizontal/vertical from the window size; the stats
      -- dashboard is the one that actually needs the room.
      winlayout = "responsive",
      wpm_goal = 100,
      numbers = false,
      symbols = false,
      -- Start in normal mode so the on-screen toggles (s/n/r/3/4/5) are live;
      -- press `i` to begin typing.
      insert_on_start = false,
      stats_filepath = vim.fn.stdpath "data" .. "/typrstats",
      -- The test buffer is an ordinary buffer, so global mappings still apply.
      -- typr's own keys are buffer-local and win, but mini.surround owns `s`
      -- globally -- which is also typr's "toggle symbols" -- so turn it off
      -- here rather than rely on that precedence. autopairs is handled by
      -- disable_filetype in plugins/autopairs.lua, cmp by the spec below.
      on_attach = function(buf)
        vim.b[buf].minisurround_disable = true
      end,
    },
  },

  -- Completion inside the typing test would suggest the next word for you.
  -- NvChad owns the cmp spec, so this only layers an `enabled` guard on top.
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local base = opts.enabled
      opts.enabled = function()
        if vim.bo.filetype == "typr" then
          return false
        end
        -- Respect whatever the previous spec decided, if anything did.
        if type(base) == "function" then
          return base()
        end
        return base ~= false
      end
    end,
  },
}

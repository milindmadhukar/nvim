-- NOTE: Colorscheme
--
-- Catppuccin Mocha, from the upstream plugin rather than base46's port of it,
-- so Neovim matches the Ghostty theme exactly.
--
-- NvChad still needs base46 -- it draws its own UI (tabufline, nvdash, the
-- cheatsheet) from base46 highlight groups that no colorscheme defines. Two
-- things keep the two from fighting:
--
--   * the colorscheme is applied *after* init.lua has dofile'd the base46
--     caches, so catppuccin has the last word on ordinary syntax groups;
--   * `:colorscheme` clears every group, so the NvChad-only ones are put back
--     afterwards, from base46 -- whose catppuccin palette lua/chadrc.lua pins
--     to the same official Mocha values these highlights use.

-- Highlight groups NvChad owns and catppuccin knows nothing about.
local function nvchad_highlights()
  for _, part in ipairs { "tbline", "statusline", "nvcheatsheet" } do
    local cache = vim.g.base46_cache .. part
    if vim.uv.fs_stat(cache) then
      dofile(cache)
    end
  end

  local mocha = require("catppuccin.palettes").get_palette "mocha"
  vim.api.nvim_set_hl(0, "NvDashAscii", { fg = mocha.blue })
  vim.api.nvim_set_hl(0, "NvDashButtons", { fg = mocha.overlay1 })
  vim.api.nvim_set_hl(0, "NvDashFooter", { fg = mocha.red })
end

-- Two snacks groups that do not agree with the rest of the editor's floats.
--
--   * catppuccin's snacks integration links SnacksNormal to `Normal`, where
--     snacks itself defaults to `NormalFloat`. A picker is a layout box with
--     the list and prompt floating inside it, so the box painted the editor
--     background (#1e1e2e) while its own children painted the float one
--     (#181825) -- the dialog came out two-tone.
--   * snacks styles the input box off `DiagnosticInfo`, giving it a cyan
--     border and title. It is the only float in this config not drawn in
--     FloatBorder blue.
--
-- Both are one-line reverts if the snacks look is preferable.
local function snacks_highlights()
  for group, link in pairs {
    SnacksNormal = "NormalFloat",
    SnacksNormalNC = "NormalFloat",
    SnacksInputNormal = "NormalFloat",
    SnacksInputBorder = "FloatBorder",
    SnacksInputTitle = "FloatTitle",
  } do
    vim.api.nvim_set_hl(0, group, { link = link })
  end
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,

    opts = {
      flavour = "mocha",
      -- Only consulted when flavour is "auto"; set flavour = "auto" to follow
      -- `background` instead of pinning Mocha.
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      show_end_of_buffer = false,
      -- Recolours :terminal, so floaterm and lazygit sit in the same palette.
      term_colors = true,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
      -- Off by default catppuccin scans every installed plugin directory on
      -- setup to guess which integrations to switch on. Every integration this
      -- config wants is named explicitly below, so that scan is ~3ms of
      -- startup spent rediscovering a list we already have.
      auto_integrations = false,
      integrations = {
        cmp = true,
        dap = true,
        dap_ui = true,
        gitsigns = true,
        harpoon = true,
        lsp_trouble = true,
        mason = true,
        mini = { enabled = true },
        navic = { enabled = true, custom_bg = "NONE" },
        noice = true,
        nvimtree = true,
        render_markdown = true,
        -- Covers the input box, the notifier, indent guides and zen mode,
        -- which used to be dressing/nvim-notify/indent-blankline/zen-mode.
        snacks = { enabled = true },
        telescope = { enabled = true },
        which_key = true,
      },
    },

    config = function(_, opts)
      require("catppuccin").setup(opts)

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("NvChadCatppuccin", { clear = true }),
        pattern = "catppuccin*",
        desc = "Re-apply NvChad's and snacks' highlight groups after catppuccin loads",
        callback = function()
          nvchad_highlights()
          snacks_highlights()
        end,
      })

      -- init.lua dofiles the base46 caches once lazy.setup() returns, which
      -- would paint straight over the colorscheme if it were set here.
      -- Scheduling puts it after that, and after `require "core"`.
      vim.schedule(function()
        vim.cmd.colorscheme "catppuccin-mocha"
      end)
    end,
  },

  -- Kept installed but never loaded, so they cost nothing at startup. Reach
  -- for one with `:Lazy load <name>` followed by `:colorscheme <name>`.
  { "folke/tokyonight.nvim", lazy = true },
  { "lunarvim/darkplus.nvim", lazy = true },
  { "Shadorain/shadotheme", lazy = true },
  { "LunarVim/synthwave84.nvim", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
}

-- Only used to reload the theme.
--
-- Nothing calls this at the moment; it is kept as the escape hatch for when
-- lua/chadrc.lua changes and the base46 cache still holds the old colours.
-- (`:Lazy build base46` does the same thing from scratch.)

return function()
  require("plenary.reload").reload_module "chadrc"
  require("plenary.reload").reload_module "nvconfig"
  require("plenary.reload").reload_module "base46"

  require("base46").load_all_highlights()

  -- base46 clears the NvChad-only groups on its way through, and it does not
  -- know about catppuccin, so put the colorscheme back on top.
  vim.cmd.colorscheme "catppuccin-mocha"
  vim.cmd "echo ''"
end

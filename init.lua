require("user.keymaps")
require("user.options")
require("user.globals")
require("user.autocommands")
require("user.plugins")
require("user.lsp")
require("user.colorscheme").load("darkplus") -- catppuccin, tokyonight-moon, synthwave84, fluoromachine, nightfox, darkplus
require("user.neovide")

require("rss").setup()

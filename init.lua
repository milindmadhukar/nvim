require("user.keymaps")
require("user.options")
require("user.plugins")
require("user.lsp")
require("user.colorscheme")
require("user.autocommands")
require("user.neovide")

vim.opt.rtp:append("~/Desktop/Code/dotfyle.nvim/")
require("dotfyle").setup() -- FOR DEVELOPEMENT ONLY

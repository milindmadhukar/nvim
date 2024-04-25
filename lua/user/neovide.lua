if not vim.g.neovide then
  return
end


require("user.colorscheme").load("darkplus")

vim.o.guifont = "Hack Nerd Font:h14"

vim.g.neovide_scale_factor = 0.75
vim.g.neovide_scroll_animation_length = 0.3
vim.g.neovide_hide_mouse_when_typing = false
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0
vim.g.neovide_window_blurred = true
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
vim.g.neovide_transparency = 0.8

vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_theme = "auto"
vim.g.neovide_refresh_rate = 144
vim.g.neovide_refresh_rate_idle = 5

vim.g.neovide_confirm_quit = true

vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_animate_command_line = true

vim.g.neovide_cursor_vfx_mode = "pixiedust"

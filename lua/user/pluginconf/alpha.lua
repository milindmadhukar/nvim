local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  vim.notify("Alpha dashboard not found", "error")
  return
end

local lazy_path = vim.fn.stdpath "data" .. "/lazy"
local num_plugins_loaded = #vim.fn.globpath(lazy_path, "*", 0, 1)

local dashboard = require "alpha.themes.dashboard"
dashboard.section.header.val = {
  "      +++++++       xxxxxxx      xxxxxxx",
  "      +:::::+        x:::::x    x:::::x ",
  "      +:::::+         x:::::x  x:::::x  ",
  "+++++++:::::+++++++    x:::::xx:::::x   ",
  "+:::::::::::::::::+     x::::::::::x    ",
  "+:::::::::::::::::+     x::::::::::x    ",
  "+++++++:::::+++++++    x:::::xx:::::x   ",
  "      +:::::+         x:::::x  x:::::x  ",
  "      +:::::+        x:::::x    x:::::x ",
  "      +++++++       xxxxxxx      xxxxxxx",
}

dashboard.section.buttons.val = {
  dashboard.button("r", "  Recent Files", ":Telescope oldfiles <CR>"),
  dashboard.button("f", "  Find File", ":Telescope find_files <CR>"),
  dashboard.button("e", "  New File", ":ene <BAR> startinsert <CR>"),
  dashboard.button("t", "  Find Text", ":Telescope live_grep <CR>"),
  dashboard.button("c", "  Restore Session For Current Directory", "<cmd>lua require('persistence').load()<cr>"),
  dashboard.button("l", "  Restore Last Session", "<cmd>lua require('persistence').load({ last = true })<cr>"),
  dashboard.button("C", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}

dashboard.section.buttons.val = {
  dashboard.button("p", "  Find Project", ":Telescope projects <CR>"),
  dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
  dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
  dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
  dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
  dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

local function footer()
  -- NOTE: requires the fortune-mod package to work
  -- local handle = io.popen("fortune")
  -- local fortune = handle:read("*a")
  -- handle:close()
  -- return fortune
  return num_plugins_loaded .. " plugins are installed "
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)

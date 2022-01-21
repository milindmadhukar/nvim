local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

local dashboard = require("alpha.themes.dashboard")
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


-- TODO: Add some way for sessions (persistence.nvim)
dashboard.section.buttons.val = {
	dashboard.button("p", "  Find Project", ":Telescope projects <CR>"),
	dashboard.button("r", "  Recent Files", ":Telescope oldfiles <CR>"),
	dashboard.button("f", "  Find File", ":Telescope find_files <CR>"),
	dashboard.button("e", "  New File", ":ene <BAR> startinsert <CR>"),
	dashboard.button("t", "  Find Text", ":Telescope live_grep <CR>"),
  dashboard.button("C", "  Restore Session For Current Directory", "<cmd>lua require('persistence').load()<cr>"),
  dashboard.button("l", "  Restore Last Session", "<cmd>lua require('persistence').load({ last = true })<cr>"),
	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
	dashboard.button("q", "  Quit", ":qa<CR>"),
}

local function footer()
-- NOTE: requires the fortune-mod package to work
	-- local handle = io.popen("fortune")
	-- local fortune = handle:read("*a")
	-- handle:close()
	-- return fortune
	return "Hold on, hold on, we're almost there"
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)

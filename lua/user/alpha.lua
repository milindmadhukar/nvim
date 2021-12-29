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
dashboard.section.buttons.val = {
	dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
	dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
	dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
	dashboard.button("s", "  Find Session", ":Telescope sessions save_current=false <CR>"),
	dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua <CR>"),
	dashboard.button("q", "  Quit", ":qa<CR>"),
}
-- 
local function footer()
-- NOTE: requires the fortune-mod package to work
	-- local handle = io.popen("fortune")
	-- local fortune = handle:read("*a")
	-- handle:close()
	-- return fortune
	return "keep rockin\', keep rollin\', keep dreamin\', keep goin\'."
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)

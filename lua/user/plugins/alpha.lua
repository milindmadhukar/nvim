local M = {
	"goolord/alpha-nvim",
	commit = "1838ae926e8d49fe5330d1498ee8289ae2c340bc",
	event = "VimEnter",
}

function M.config()
	local dashboard = require("alpha.themes.dashboard")

	local function button(sc, txt, keybind, keybind_opts)
		local b = dashboard.button(sc, txt, keybind, keybind_opts)
		b.opts.hl_shortcut = "Include"
		return b
	end

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
		button("p", "  Find Project", ":Telescope projects <CR>"),
		button("f", "  Find file", ":Telescope find_files <CR>"),
		button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
		button("t", "  Find text", ":Telescope live_grep <CR>"),
		button("e", "  New file", ":ene <BAR> startinsert <CR>"),
		button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
		button("q", "  Quit Neovim", ":qa<CR>"),
	}

	local function footer()
		return "High On Life till the day we die."
	end

	dashboard.section.footer.val = footer()

	dashboard.section.header.opts.hl = "Keyword"
	dashboard.section.buttons.opts.hl = "Include"
	dashboard.section.footer.opts.hl = "Type"

	dashboard.opts.opts.noautocmd = true
	require("alpha").setup(dashboard.opts)

	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyVimStarted",
		callback = function()
			local stats = require("lazy").stats()
			local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			dashboard.section.footer.val = "Loaded " .. stats.count .. " plugins in " .. ms .. "ms"
			pcall(vim.cmd.AlphaRedraw)
		end,
	})

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = { "AlphaReady" },
		callback = function()
			vim.cmd([[
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]])
		end,
	})
end

return M

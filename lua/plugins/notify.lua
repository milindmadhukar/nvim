local M = {
	"rcarriga/nvim-notify",
	lazy = false,
}

function M.config()
	local notify = require("notify")
	notify.setup({
		-- Animation style (see below for details)
		stages = "fade_in_slide_out",

		-- Function called when a new window is opened, use for changing win settings/config
		on_open = nil,

		-- Function called when a window is closed
		on_close = nil,

		-- Render function for notifications. See notify-render()
		render = "default",

		-- Default timeout for notifications
		timeout = 175,

		-- For stages that change opacity this is treated as the highlight behind the window
		-- Set this to either a highlight group or an RGB hex value e.g. "#000000"
		background_colour = "#000000",

		-- Minimum width for notification windows
		minimum_width = 10,

		-- Icons for the different levels
		icons = {
			ERROR = " ",
			WARN = " ",
			INFO = " ",
			DEBUG = " ",
			TRACE = "󰴠 ",
		},
	})

	vim.notify = notify

	local notify_filter = vim.notify
	vim.notify = function(msg, ...)
		if msg:match("character_offset must be called") then
			return
		end
		if msg:match("method textDocument") then
			return
		end
		if msg:match("warning: multiple different client offset_encodings") then
			return
		end

		if
			msg:match(
				"modicator.nvim: modicator requires `number` to be set. Run `:set number` or add `vim.o.number = true` to your init.lua"
			)
		then
			return
		end

		if
			msg:match(
				"modicator.nvim: modicator requires `cursorline` to be set. Run `:set cursorline` or add `vim.o.cursorline = true` to your init.lua"
			)
		then
			return
		end

		notify_filter(msg, ...)
	end
end

return M

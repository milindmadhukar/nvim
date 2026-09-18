-- Notification noise filter.
--
-- These are messages plugins emit that say nothing actionable -- LSP offset
-- encoding chatter, modicator's setup nagging. It used to live in the
-- nvim-notify spec; with snacks owning vim.notify it wraps whatever handler is
-- installed instead of any one plugin's.

local M = {}

local suppressed = {
	"character_offset must be called",
	"method textDocument",
	"warning: multiple different client offset_encodings",
	"modicator%.nvim: modicator requires `number` to be set",
	"modicator%.nvim: modicator requires `cursorline` to be set",
}

local installed = false

---Wrap the current `vim.notify` so the patterns above never reach it.
function M.install()
	if installed then
		return
	end

	installed = true

	local notify = vim.notify

	vim.notify = function(msg, ...)
		if type(msg) == "string" then
			for _, pattern in ipairs(suppressed) do
				if msg:match(pattern) then
					return
				end
			end
		end

		return notify(msg, ...)
	end
end

return M

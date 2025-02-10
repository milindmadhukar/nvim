local M = {}

local char_to_hex = function(c)
	return string.format("%%%02X", string.byte(c))
end

local function urlencode(text)
	if text == nil then
		return
	end
	text = text:gsub("\n", "\r\n")
	text = text:gsub("([^%w ])", char_to_hex)
	text = text:gsub(" ", "+")
	-- Strip the text
	text = text:gsub("%%0D%%0A$", "")
	return text
end

function M.generate_carbon_screenshot()
	local selection = require("user.functions").capture_selection()

	if selection[1] == "" then
		selection[1] = vim.fn.join(vim.fn.getline(1, "$"), "\n")
	end

	selection[1] = urlencode(selection[1])

	local url = "https://carbon.now.sh/?bg=rgba%2858%2C64%2C75%2C1%29&t=synthwave-84&wt=none&l="
		.. "auto"
		.. "&width=680&ds=true&dsyoff=20px&dsblur=68px&wc=true&wa=true&pv=56px&ph=56px&ln=false&fl=1&fm=Hack&fs=14px&lh=133%25&si=false&es=2x&wm=false&code="
		.. selection[1]

	vim.fn.jobstart({ "xdg-open", url }, { detach = true })

	vim.notify("Opened carbon in browser", "info")
end

return M

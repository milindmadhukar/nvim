local M = {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	enabled = false,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
}

function M.config()
	local home = vim.fn.expand("$HOME")
	require("chatgpt").setup({
		api_key_cmd = "gpg --decrypt " .. home .. "/openaiapikey.txt.gpg",
	})
end

return M

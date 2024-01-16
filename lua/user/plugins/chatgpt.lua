local M = {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	-- enabled = false,
  cmd = {"ChatGPT", "ChatGPTActAs", "ChatCPTCompleteCode", "ChatGPTRun"},
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
		openai_params = {
			model = "gpt-4",
			frequency_penalty = 0,
			presence_penalty = 0,
			max_tokens = 3000,
			temperature = 0,
			top_p = 1,
			n = 1,
		},
	})
end

return M

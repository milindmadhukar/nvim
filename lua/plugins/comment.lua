local M = {
	"numToStr/Comment.nvim",
	enabled = true,
	lazy = false,
	event = "BufRead",
	dependencies = {
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			event = "VeryLazy",
		},
	},
}

function M.config()
	vim.g.skip_ts_context_commentstring_module = true
	---@diagnostic disable: missing-fields
	require("ts_context_commentstring").setup({
enable_autocmd = false,
})

  local api = require("Comment.api")
  local keymap = vim.keymap.set

  -- Toggle comment in normal mode
  keymap("n", "<leader>/", api.toggle.linewise.current, { desc = "Toggle Comment" })

  -- Toggle comment in visual mode
  keymap("v", "<leader>/", function()
       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<ESC>', true, false, true), 'nx', false)
       api.toggle.linewise(vim.fn.visualmode())
  end, { desc = "Toggle Comment" })

	require("Comment").setup({
pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	})
end

return M

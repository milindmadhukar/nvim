local M = {
	"rmagatti/auto-session",
	enabled = false,
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"rmagatti/session-lens",
	},
}

function M.config()
	local opts = {
		log_level = "info",
		auto_session_enable_last_session = false,
		auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
		auto_session_enabled = true,
		auto_save_enabled = false,
		auto_restore_enabled = false,
		auto_session_use_git_branch = true,
		-- the configs below are lua only
		bypass_session_save_file_types = { "alpha", "NvimTree" },
	}

	vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos"

	require("telescope").load_extension("session-lens")

	require("session_lens").setup({
		path_display = { "shorten" },
		previewer = false,
		prompt_title = "Sessions",
	})

	require("auto_session").setup(opts)
end

return M

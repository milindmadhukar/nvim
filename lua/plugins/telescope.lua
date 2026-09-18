local M = {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		-- Provides the `projects` extension backing `:Telescope projects`.
		{ "DrKJeff16/project.nvim" },
		-- Compiled fzf sorter. Telescope's pure-Lua sorter is the bottleneck on
		-- large repos; this replaces it. Needs `make` and a C compiler at install
		-- time -- if the build fails, the pcall loop below just skips the extension.
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		-- Persistent, cwd-scoped prompt history for the <C-n>/<C-p> mappings
		-- below. Without it telescope's history is in-memory and dies with the
		-- session. sqlite.lua is its backing store.
		{ "nvim-telescope/telescope-smart-history.nvim" },
		{ "kkharji/sqlite.lua" },
	},
}

function M.config()
	local telescope = require("telescope")
	local actions = require("telescope.actions")

	telescope.setup({
		defaults = {
			-- Backing store for telescope-smart-history. Loading the
			-- `smart_history` extension installs the handler that scopes
			-- recall to the current working directory.
			history = {
				path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
				limit = 100,
			},

			prompt_prefix = " ",
			selection_caret = " ",
			path_display = { "smart" },

			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
			},

			selection_strategy = "reset",
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					prompt_position = "top",
					preview_width = 0.55,
					results_width = 0.8,
				},
				vertical = {
					mirror = false,
				},
				width = 0.87,
				height = 0.80,
				preview_cutoff = 120,
			},

			file_ignore_patterns = { "node_modules" },
			winblend = 0,
			border = {},
			borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			color_devicons = true,

			mappings = {
				i = {
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,

					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,

					["<C-c>"] = actions.close,

					["<Down>"] = actions.move_selection_next,
					["<Up>"] = actions.move_selection_previous,

					["<CR>"] = actions.select_default,
					["<C-x>"] = actions.select_horizontal,
					["<C-v>"] = actions.select_vertical,
					["<C-t>"] = actions.select_tab,

					["<C-u>"] = actions.preview_scrolling_up,
					["<C-d>"] = actions.preview_scrolling_down,

					["<PageUp>"] = actions.results_scrolling_up,
					["<PageDown>"] = actions.results_scrolling_down,

					["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
					["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
					["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
					["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					["<C-l>"] = actions.complete_tag,
					["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
				},

				n = {
					["<esc>"] = actions.close,
					["<CR>"] = actions.select_default,
					["<C-x>"] = actions.select_horizontal,
					["<C-v>"] = actions.select_vertical,
					["<C-t>"] = actions.select_tab,

					["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
					["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
					["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
					["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

					["j"] = actions.move_selection_next,
					["k"] = actions.move_selection_previous,
					["H"] = actions.move_to_top,
					["M"] = actions.move_to_middle,
					["L"] = actions.move_to_bottom,

					["<Down>"] = actions.move_selection_next,
					["<Up>"] = actions.move_selection_previous,
					["gg"] = actions.move_to_top,
					["G"] = actions.move_to_bottom,

					["<C-u>"] = actions.preview_scrolling_up,
					["<C-d>"] = actions.preview_scrolling_down,

					["<PageUp>"] = actions.results_scrolling_up,
					["<PageDown>"] = actions.results_scrolling_down,

					["q"] = actions.close,
					["?"] = actions.which_key,
				},
			},
		},
		pickers = {
			-- Default configuration for builtin pickers goes here:
			-- picker_name = {
			--   picker_config_key = value,
			--   ...
			-- }
			-- Now the picker_config_key will be applied every time you call this
			-- builtin picker
		},
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
	})

	-- pcall so a missing/failed extension degrades to "that picker is gone"
	-- instead of taking the whole telescope config down with it.
	for _, ext in ipairs({ "fzf", "smart_history", "projects" }) do
		local ok, err = pcall(telescope.load_extension, ext)
		if not ok then
			vim.notify("telescope: failed to load extension '" .. ext .. "'\n" .. tostring(err), vim.log.levels.WARN)
		end
	end
end

return M

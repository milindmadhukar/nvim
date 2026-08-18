local M = {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = { "<leader>h" },
}

-- NOTE: every telescope require lives inside this function on purpose.
-- Requiring telescope.config at module scope ran during lazy's spec import and
-- pulled telescope (and telescope-ui-select) into startup, costing ~9ms.
local function toggle_telescope(harpoon_files)
	local conf = require("telescope.config").values
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

function M.config()
	local harpoon = require("harpoon")

	harpoon:setup()

	vim.keymap.set("n", "<leader>ht", function()
		toggle_telescope(harpoon:list())
	end, { desc = "Harpoon | Telescope window" })
end

return M

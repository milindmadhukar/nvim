local M = {
	"RRethy/vim-illuminate",
	event = "VeryLazy",
}

function M.config()
	vim.g.Illuminate_ftblacklist = { "alpha", "NvimTree", "nvdash" }
	vim.api.nvim_set_keymap(
		"n",
		"<a-n>",
		'<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
		{ noremap = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<a-p>",
		'<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
		{ noremap = true }
	)

	require("illuminate").configure({
		filetypes_denylist = {
			"mason",
			"harpoon",
			"DressingInput",
			"NeogitCommitMessage",
			"qf",
			"dirvish",
			"oil",
			"minifiles",
			"fugitive",
			"alpha",
			"NvimTree",
			"lazy",
			"NeogitStatus",
			"Trouble",
			"netrw",
			"lir",
			"DiffviewFiles",
			"Outline",
			"Jaq",
			"spectre_panel",
			"toggleterm",
			"DressingSelect",
			"TelescopePrompt",
		},
	})
end

return M

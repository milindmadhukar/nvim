local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
	vim.notify("Neorg not found", "error")
	return
end

neorg.setup({
	load = {
		["core.defaults"] = {},
		["core.concealer"] = {},
		["core.dirman"] = {
			config = {
				workspaces = {
					notes = "~/notes",
					twig = "~/notes/this-week-in-garrix",
				},
			},
		},
		["core.completion"] = {
			config = {
				engine = "nvim-cmp",
			},
		},
		["core.export"] = {
			config = {},
		},
		["core.export.markdown"] = {
			config = {
				extensions = "all",
			},
		},
		["core.integrations.nvim-cmp"] = {
			config = {},
		},
		["core.integrations.telescope"] = {},
	},
})

vim.wo.foldlevel = 99
vim.wo.conceallevel = 3

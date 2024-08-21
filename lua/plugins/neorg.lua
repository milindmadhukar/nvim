local M = {
	"nvim-neorg/neorg",
	build = ":Neorg sync-parsers",
	dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-neorg/neorg-telescope" } },
}

function M.config()
	require("neorg").setup({
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
end

return M

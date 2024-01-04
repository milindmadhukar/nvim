return {
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
			telemetry = {
				enable = false,
			},
		},
	},
}

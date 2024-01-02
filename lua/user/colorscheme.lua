local M = {}

function M.load(colorscheme)
	if colorscheme == nil then
		colorscheme = "tokyonight-moon"
	end

	local lualine_theme = colorscheme

	if colorscheme == "catppuccin" then
		vim.g.catppuccin_flavour = "mocha" --latte, frappe, macchiato, mocha
		local catppuccin_status_ok, catppuccin = pcall(require, "catppuccin")
		if not catppuccin_status_ok then
			vim.notify("Catppuccin not found, couldn't set colorscheme", "error")
			return
		end
		catppuccin.setup()
		local status_transparent_ok, _ = pcall(vim.cmd, "TransparentDisable")
		if not status_transparent_ok then
			return
		end
	end

  local nightfox_colors = {"carbonfox", "dawnfox", "dayfox", "nightfox", "nordfox", "terafox", "duskfox"}

	if require("user.functions").has_value(nightfox_colors, colorscheme) then
		lualine_theme = "nightfox"

		require("nightfox").setup({
			options = {
				-- Compiled file's destination location
				compile_path = vim.fn.stdpath("cache") .. "/nightfox",
				compile_file_suffix = "_compiled", -- Compiled file suffix
				transparent = false, -- Disable setting background
				terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
				dim_inactive = false, -- Non focused panes set to alternative background
				module_default = true, -- Default enable value for modules
				colorblind = {
					enable = false, -- Enable colorblind support
					simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
					severity = {
						protan = 0, -- Severity [0,1] for protan (red)
						deutan = 0, -- Severity [0,1] for deutan (green)
						tritan = 0, -- Severity [0,1] for tritan (blue)
					},
				},
				styles = { -- Style to be applied to different syntax groups
					comments = "italics", -- Value is any valid attr-list value `:help attr-list`
					conditionals = "NONE",
					constants = "NONE",
					functions = "NONE",
					keywords = "NONE",
					numbers = "NONE",
					operators = "NONE",
					strings = "NONE",
					types = "bold",
					variables = "NONE",
				},
				inverse = { -- Inverse highlight for different types
					match_paren = false,
					visual = false,
					search = false,
				},
				modules = { -- List of various plugins and additional options
					-- ...
				},
			},
			palettes = {},
			specs = {},
			groups = {},
		})
	end

	if colorscheme == "synthwave84" then
		local status_transparent_ok, _ = pcall(vim.cmd, "TransparentDisable")
		if not status_transparent_ok then
			return
		end

		require("synthwave84").setup({
			glow = {
				error_msg = true,
				type2 = true,
				func = true,
				keyword = true,
				operator = true,
				buffer_current_target = true,
				buffer_visible_target = true,
				buffer_inactive_target = true,
			},
		})
	end

	-- Check if a string starts with "tokyonight"
	if colorscheme:sub(1, 10) == "tokyonight" then
		lualine_theme = "tokyonight"
		local status_transparent_ok, _ = pcall(vim.cmd, "TransparentEnable")
		if not status_transparent_ok then
			return
		end
	end

	local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
	if not status_ok then
		return
	end

	local lualine_status_ok, lualine = pcall(require, "lualine")
	if not lualine_status_ok then
		vim.notify("Lualine not found", "error")
		return
	end

	lualine.setup({
		options = {
			theme = lualine_theme,
		},
	})

	vim.cmd("let &fcs='eob: '")

	local transparent_status_ok, transparent = pcall(require, "transparent")
	if not transparent_status_ok then
		vim.notify("Transparency plugin not found", "error")
		return
	end

	transparent.setup({
		extra_groups = {
			"MsgArea",
			"NvimTreeNormal",
			"NvimTreeNormalNC",
			"EndOfBuffer",
			"Folded",
			"FoldColumn",
			"VertSplit",
			"NormalFloat",
			"FloatBorder",
			"Pmenu",
			"Directory",
			"Debug",
			"NonText",
			"LspFloatWinNormal",
			"TargetWord",
			"ReferencesCount",
			"DefinitionCount",
			"TargetFileName",
			"DefinitionIcon",
			"ReferencesIcon",
			"ProviderTruncateLine",
			"DiagnosticTruncateLine",
			"DiagnosticError",
			"DiagnosticWarning",
			"DiagnosticInformation",
			"DiagnosticHint",
			"DefinitionPreviewTitle",
			"LineDiagTuncateLine",
			"Normal",
			"SignColumn",
			"NormalNC",
			"TelescopeNormal",
			"TelescopeNormalNC",
			"TelescopeBorder",
			"TelescopeBorderNC",
			"TelescopePromptBorder",
			"WinSeparator",
			"NotifyERRORBody",
			"NotifyWARNBody",
			"NotifyINFOBody",
			"NotifyDEBUGBody",
			"NotifyTRACEBody",
			"NotifyERRORBorder",
			"NotifyWARNBorder",
			"NotifyINFOBorder",
			"NotifyDEBUGBorder",
			"NotifyTRACEBorder",
			"NoiceFormatProgressDone",
			"NoiceFormatProgressTodo",
			"NoiceFormatTitle",
			"NoiceLspProgressClient",
			"NoiceLspProgressSpinner",
			"NoiceLspProgressTitle",
			"NoiceMini",
			"NoicePopupmenuMatch",

			-- "LspSagaFinderSelection",
			-- "LspSagaBorderTitle",
			-- "SagaShadow",
			-- "LspSagaFinderSelection",
			-- "LspSagaShTruncateLine",
			-- "LspSagaDocTruncateLine",
			-- "LspSagaCodeActionTitle",
			-- "LspSagaCodeActionTruncateLine",
			-- "LspSagaCodeActionContent",
			-- "LspSagaRenamePromptPrefix",
			-- "LspSagaRenameBorder",
			-- "LspSagaHoverBorder",
			-- "LspSagaSignatureHelpBorder",
			-- "LspSagaCodeActionBorder",
			-- "LspSagaAutoPreview",
			-- "LspSagaDefPreviewBorder",
		},
		exclude_groups = {},
	})
end

return M

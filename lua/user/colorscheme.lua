-- local colorscheme = "catppuccin"
local colorscheme = "tokyonight-moon"
-- local colorscheme = "shado"

local lualine_theme = colorscheme

if colorscheme == "catppuccin" then
	vim.g.catppuccin_flavour = "latte" --latte, frappe, macchiato, mocha
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

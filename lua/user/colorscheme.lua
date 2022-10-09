-- local colorscheme = "catppuccin"
local colorscheme = "tokyonight-moon"
-- local colorscheme = "templeos"

local is_transparent = true

if colorscheme == "catppuccin" then
	vim.g.catppuccin_flavour = "mocha" --latte, frappe, macchiato, mocha
	local catppuccin_status_ok, catppuccin = pcall(require, "catppuccin")
	if not catppuccin_status_ok then
		print("Catpucchin is not installed, can't set colorscheme")
		return
	end
	catppuccin.setup()
	is_transparent = false
end

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end

local lualine_status_ok, lualine = pcall(require, "lualine")
if not lualine_status_ok then
	return
end

lualine.setup({
	options = {
		theme = colorscheme,
	},
})

vim.cmd("let &fcs='eob: '")

local transparent_status_ok, transparent = pcall(require, "transparent")
if not transparent_status_ok then
	return
end

transparent.setup({
	enable = is_transparent,
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
		"LspFloatWinBorder",
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
		"LspLinesDiagBorder",
		"Normal",
		"SignColumn",
		"NormalNC",
		"TelescopeNormal",
		"TelescopeNormalNC",
		"TelescopeBorder",
		"TelescopeBorderNC",
		"TelescopePromptBorder",
		"WinSeparator",
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
	exclude = {},
})

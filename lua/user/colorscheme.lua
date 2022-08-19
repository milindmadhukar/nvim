local colorscheme = "tokyonight"

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	callback = function()
		vim.cmd([[
      hi Normal ctermbg=none guibg=none
      hi SignColumn ctermbg=none guibg=none
      hi NormalNC ctermbg=none guibg=none
      hi MsgArea ctermbg=none guibg=none
      hi NvimTreeNormal ctermbg=none guibg=none
      hi NvimTreeNormalNC ctermbg=none guibg=none
      hi EndOfBuffer ctermbg=none guibg=none
      hi LineNr guibg=none ctermbg=none
      hi Folded guibg=none ctermbg=none
      hi FoldColumn guibg=none ctermbg=none
      hi VertSplit guibg=none ctermbg=none
      hi NormalFloat guibg=none ctermbg=none
      hi FloatBorder guibg=none ctermbg=none
      hi Pmenu guibg=none ctermbg=none
      hi Directory guibg=none ctermbg=none
      hi Debug guibg=none ctermbg=none
      hi NonText guibg=none ctermbg=none
      hi LspSagaFinderSelection guibg=none ctermbg=none
      hi LspFloatWinNormal guibg=none ctermbg=none
      hi LspFloatWinBorder guibg=none ctermbg=none
      hi LspSagaBorderTitle guibg=none ctermbg=none
      hi TargetWord guibg=none ctermbg=none
      hi ReferencesCount guibg=none ctermbg=none
      hi DefinitionCount guibg=none ctermbg=none
      hi TargetFileName guibg=none ctermbg=none
      hi DefinitionIcon guibg=none ctermbg=none
      hi ReferencesIcon	guibg=none ctermbg=none
      hi ProviderTruncateLine	guibg=none ctermbg=none
      hi SagaShadow guibg=none ctermbg=none
      hi LspSagaFinderSelection guibg=none ctermbg=none
      hi DiagnosticTruncateLine	guibg=none ctermbg=none
      hi DiagnosticError guibg=none ctermbg=none
      hi DiagnosticWarning guibg=none ctermbg=none
      hi DiagnosticInformation guibg=none ctermbg=none
      hi DiagnosticHint	guibg=none ctermbg=none
      hi DefinitionPreviewTitle	guibg=none ctermbg=none
      hi LspSagaShTruncateLine guibg=none ctermbg=none
      hi LspSagaDocTruncateLine	guibg=none ctermbg=none
      hi LineDiagTuncateLine guibg=none ctermbg=none
      hi LspSagaCodeActionTitle	guibg=none ctermbg=none
      hi LspSagaCodeActionTruncateLine guibg=none ctermbg=none
      hi LspSagaCodeActionContent	guibg=none ctermbg=none
      hi LspSagaRenamePromptPrefix guibg=none ctermbg=none
      hi LspSagaRenameBorder guibg=none ctermbg=none
      hi LspSagaHoverBorder guibg=none ctermbg=none
      hi LspSagaSignatureHelpBorder	guibg=none ctermbg=none
      hi LspSagaCodeActionBorder guibg=none ctermbg=none
      hi LspSagaAutoPreview	guibg=none ctermbg=none
      hi LspSagaDefPreviewBorder guibg=none ctermbg=none
      hi LspLinesDiagBorder guibg=none ctermbg=none
    ]])
	end,
})

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end

vim.cmd("let &fcs='eob: '")

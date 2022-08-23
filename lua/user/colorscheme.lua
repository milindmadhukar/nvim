local colorscheme = "tokyonight"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end

vim.cmd("let &fcs='eob: '")

local transparent_status_ok, transparent = pcall(require, "transparent")
if not transparent_status_ok then
  return
end

transparent.setup({
  enable = true,
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
    "LspSagaFinderSelection",
    "LspFloatWinNormal",
    "LspFloatWinBorder",
    "LspSagaBorderTitle",
    "TargetWord",
    "ReferencesCount",
    "DefinitionCount",
    "TargetFileName",
    "DefinitionIcon",
    "ReferencesIcon",
    "ProviderTruncateLine",
    "SagaShadow",
    "LspSagaFinderSelection",
    "DiagnosticTruncateLine",
    "DiagnosticError",
    "DiagnosticWarning",
    "DiagnosticInformation",
    "DiagnosticHint",
    "DefinitionPreviewTitle",
    "LspSagaShTruncateLine",
    "LspSagaDocTruncateLine",
    "LineDiagTuncateLine",
    "LspSagaCodeActionTitle",
    "LspSagaCodeActionTruncateLine",
    "LspSagaCodeActionContent",
    "LspSagaRenamePromptPrefix",
    -- "LspSagaRenameBorder",
    -- "LspSagaHoverBorder",
    -- "LspSagaSignatureHelpBorder",
    -- "LspSagaCodeActionBorder",
    -- "LspSagaAutoPreview",
    -- "LspSagaDefPreviewBorder",
    -- "LspLinesDiagBorder",
  },
  exclude = {},
})

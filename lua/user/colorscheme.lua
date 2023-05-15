-- local colorscheme = "catppuccin"
local colorscheme = "tokyonight-moon"
-- local colorscheme = "shado"

local lualine_theme = colorscheme
local is_transparent = true

if colorscheme == "catppuccin" then
  vim.g.catppuccin_flavour = "mocha" --latte, frappe, macchiato, mocha
  local catppuccin_status_ok, catppuccin = pcall(require, "catppuccin")
  if not catppuccin_status_ok then
    vim.notify("Catppuccin not found, couldn't set colorscheme", "error")
    return
  end
  catppuccin.setup()
  is_transparent = false
end

-- Check if a string starts with "tokyonight"
if colorscheme:sub(1, 10) == "tokyonight" then
  lualine_theme = "tokyonight"
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

lualine.setup {
  options = {
    theme = lualine_theme,
  },
}

vim.cmd "let &fcs='eob: '"

local transparent_status_ok, transparent = pcall(require, "transparent")
if not transparent_status_ok then
  vim.notify("Transparency plugin not found", "error")
  return
end

transparent.setup {
  groups = {
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
}

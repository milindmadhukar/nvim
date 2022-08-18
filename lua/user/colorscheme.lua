local colorscheme = "tokyonight"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end

vim.cmd [[
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
]]


vim.cmd "let &fcs='eob: '"

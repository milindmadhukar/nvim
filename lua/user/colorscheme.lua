vim.cmd [[
try
  colorscheme tokyonight
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]


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
hi Pmenu guibg=none ctermbg=none
hi PmenuSbar guibg=none ctermbg=none
hi PmenuSel guibg=none ctermbg=none
hi PmenuThumb guibg=none ctermbg=none
]]


vim.cmd "let &fcs='eob: '"


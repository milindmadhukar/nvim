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
hi EndOfBuffer ctermbg=none guibg=none
hi LineNr guibg=none ctermbg=none
hi Folded guibg=none ctermbg=none
hi NonText guibg=none ctermbg=none
hi SpecialKey guibg=none ctermbg=none
hi VertSplit guibg=none ctermbg=none
]]

-- hi TelescopeSelection guibg=none ctermbg=none
-- hi TelescopeMatching guibg=none ctermbg=none
-- hi TelescopeBorder guibg=none ctermbg=none
-- hi TelescopePromptPrefix guibg=none ctermbg=none
-- ]]

vim.cmd "let &fcs='eob: '"

require "nvchad.autocmds"

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Manage kitty padding
-- TODO: Leave padding is super weird, too big, fix this and we can use, maybe also check if kitty is running and then do this.
--
-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	command = ":silent !kitty @ set-spacing padding=0 margin=0",
-- })
--
-- vim.api.nvim_create_autocmd("VimLeavePre", {
-- 	command = ":silent !kitty @ set-spacing padding=20 margin=10",
-- })

-- Use 'q' to quit from common plugins
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
	end,
})

-- Remove statusline and tabline when in Alpha
vim.api.nvim_create_autocmd({ "User" }, {
	pattern = { "AlphaReady" },
	callback = function()
		vim.cmd([[
      set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]])
	end,
})

vim.cmd("autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif")

-- Highlight Yanked Text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
	callback = function()
		vim.cmd("quit")
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.java" },
	callback = function()
		vim.lsp.codelens.refresh()
	end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		vim.cmd("hi link illuminatedWord LspReferenceText")
	end,
})

-- Disable illuminate when file too big
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	callback = function()
		local line_count = vim.api.nvim_buf_line_count(0)
		if line_count >= 5000 then
			-- TODO: Maybe turn off highlighting too
			vim.cmd("IlluminatePauseBuf")
		end
	end,
})

-- Autocommand that runs before a colorscheme is set
-- vim.api.nvim_create_autocmd({ "ColorSchemePre" }, {
--   callback = function()
--     -- Get current colorscheme
--     local colorscheme = vim.g.colors_name
--     if colorscheme == 'tokyonight' then
--       colorscheme = 'tokyonight-moon'
--     end
--     require("user.colorscheme").load(colorscheme)
--   end,
-- })

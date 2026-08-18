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

vim.cmd("autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif")

-- Highlight Yanked Text
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
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

-- Organize imports on save for Go files.
-- Must be synchronous, so this uses buf_request_sync rather than
-- vim.lsp.buf.code_action{apply=true}, which returns before BufWritePre ends.
-- gopls answers source.organizeImports with a workspace edit, so the old
-- vim.lsp.buf.execute_command fallback (removed in 0.11) is not needed.
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		local client = vim.lsp.get_clients({ bufnr = 0, name = "gopls" })[1]
		if not client then
			return
		end

		local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
		params.context = { only = { "source.organizeImports" }, diagnostics = {} }

		local responses = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
		for _, response in pairs(responses or {}) do
			for _, action in pairs(response.result or {}) do
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
				end
			end
		end
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

require "nvchad.autocmds"

-- Open nvdash on an empty startup buffer.
--
-- This replaces NvChad's own hook (ui/lua/nvchad/au.lua:5-14), which chadrc
-- disables via nvdash.load_on_startup = false. Upstream captures the startup
-- scratch buffer, opens nvdash, then deletes that buffer *unconditionally* --
-- all inside a vim.schedule(). Anything that disposes of the scratch buffer
-- before that tick runs (`nvim +Telescope find_files`, a -c command that opens
-- a file, a session restorer) leaves the delete pointing at a dead id, and it
-- throws "Invalid buffer id: N" from nvim_buf_delete.
--
-- Same behaviour, but the buffer is revalidated before being deleted.
vim.schedule(function()
	local buf = vim.api.nvim_get_current_buf()

	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	-- Only take over a genuinely empty start: no unsaved edits, and either no
	-- file name at all or `nvim <dir>`.
	if vim.api.nvim_get_option_value("modified", { buf = buf }) then
		return
	end

	local name = vim.api.nvim_buf_get_name(buf)
	if name ~= "" and vim.fn.isdirectory(name) ~= 1 then
		return
	end

	require("nvchad.nvdash").open()

	-- open() switches away from `buf`; only drop it if it is still around and is
	-- not the buffer nvdash just landed on.
	if buf ~= vim.api.nvim_get_current_buf() and vim.api.nvim_buf_is_valid(buf) then
		pcall(vim.api.nvim_buf_delete, buf, { force = true, unload = false })
	end
end)

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

-- Close Neovim when nvim-tree is the only thing left. `winnr('$')` counts
-- floating windows, so the vimscript one-liner this replaces also fired when a
-- float was dismissed over a lone tree -- closing a picker, a menu or floaterm
-- took the whole editor with it. utils.quit ignores floats, and asks first.
local nvimtree_quit_snoozed = false

vim.api.nvim_create_autocmd("BufEnter", {
	nested = true,
	callback = function()
		local quit = require("utils.quit")

		if vim.bo.filetype ~= "NvimTree" then
			-- Back in a real buffer: arm the rule again.
			if not quit.is_prompting() then
				nvimtree_quit_snoozed = false
			end

			return
		end

		-- Declining the prompt hands focus back to the tree, which fires this
		-- autocmd again; without the snooze that is an unclosable loop.
		if nvimtree_quit_snoozed or not quit.would_exit() then
			return
		end

		quit.confirm("quit", {
			on_cancel = function()
				nvimtree_quit_snoozed = true
			end,
		})
	end,
})

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

-- vim-illuminate's highlight link and its 5000-line bail-out lived here.
-- snacks.words highlights through the LSP's own LspReference* groups, and
-- snacks.bigfile handles backing off on huge files.

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

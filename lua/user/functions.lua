local M = {}

function M.remove_augroup(name)
	if vim.fn.exists("#" .. name) == 1 then
		vim.cmd("au! " .. name)
	end
end

-- get length of current word
function M.get_word_length()
	local word = vim.fn.expand("<cword>")
	return #word
end

function M.toggle_option(option)
	local value = not vim.api.nvim_get_option_value(option, {})
	vim.opt[option] = value
	vim.notify(option .. " set to " .. tostring(value))
end

function M.toggle_tabline()
	local value = vim.api.nvim_get_option_value("showtabline", {})

	if value == 2 then
		value = 0
	else
		value = 2
	end

	vim.opt.showtabline = value

	vim.notify("showtabline" .. " set to " .. tostring(value))
end

local diagnostics_active = true
function M.toggle_diagnostics()
	diagnostics_active = not diagnostics_active
	if diagnostics_active then
		vim.diagnostic.show()
	else
		vim.diagnostic.hide()
	end
end

function M.sourcefile()
	vim.cmd(":w")
	vim.cmd(":source %")
end

function M.isempty(s)
	return s == nil or s == ""
end

function M.get_buf_option(opt)
	local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
	if not status_ok then
		return nil
	else
		return buf_option
	end
end

function M.smart_quit()
	local bufnr = vim.api.nvim_get_current_buf()
	local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
	if modified then
		vim.ui.input({
			prompt = "You have unsaved changes. Quit anyway? (y/n) ",
		}, function(input)
			if input == "y" then
				vim.cmd("qa!")
			end
		end)
	else
		vim.cmd("qa!")
	end
end

function M.enable_format_on_save()
	vim.cmd([[
    augroup format_on_save
      autocmd!
      autocmd BufWritePre * lua vim.lsp.buf.format({async = true})
    augroup end
  ]])
	vim.notify("Enabled format on save")
end

function M.disable_format_on_save()
	M.remove_augroup("format_on_save")
	vim.notify("Disabled format on save")
end

function M.toggle_format_on_save()
	if vim.fn.exists("#format_on_save#BufWritePre") == 0 then
		M.enable_format_on_save()
	else
		M.disable_format_on_save()
	end
end

function M.handle_buffer_close()
	local current_bufnr = vim.api.nvim_get_current_buf()
	local buffer_count = 0
	local buffers = vim.api.nvim_list_bufs()

	for _, bufnr in ipairs(buffers) do
		if vim.fn.buflisted(bufnr) == 1 then
			buffer_count = buffer_count + 1
		end
	end

	if buffer_count == 1 then
		vim.cmd("Alpha")
		vim.cmd("bwipeout " .. current_bufnr)
	else
		vim.cmd("bdelete")
	end
end

function M.export_neorg_to_md()
	-- Get currently opened file name without extension
	local filename = vim.fn.expand("%:t:r")
	vim.cmd("Neorg export to-file " .. filename .. ".md")
end

function M.capture_selection()
	local buf = vim.api.nvim_get_current_buf()

	-- Get the line numbers for the start '< and end '> of the visual selection
	local start_line = vim.fn.line("'<") - 1 -- 0-based indexing
	local end_line = vim.fn.line("'>")

	-- Get the lines in the visual selection
	local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
	-- Concatenate the lines into a single string
	local text = table.concat(lines, "\n")

	-- Get the current file name and extract its extension
	local filename = vim.fn.expand("%:t")
	local filetype = filename:match("^.+(%..+)$")

	if filetype == nil then
		filetype = vim.bo.filetype -- fallback to Vim's filetype if no extension found
	end

	return { text, filetype }
end

function M.has_value(tab, val)
	for _, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

return M

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
	-- nvim_buf_get_option is deprecated; vim.bo indexes the same buffer options.
	local status_ok, buf_option = pcall(function()
		return vim.bo[0][opt]
	end)
	if not status_ok then
		return nil
	else
		return buf_option
	end
end

-- Quitting lives in utils/quit.lua; it confirms whether or not anything is
-- unsaved, and covers ZZ/ZQ and the :q family as well as <leader>q.

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

-- Closing a buffer, the way an editor with a tab bar is expected to do it:
-- the window keeps its place, and unsaved work gets a dialog rather than a
-- silent refusal.
--
-- Plain `:bdelete` cannot be used. When the buffer being deleted is the only
-- one a window holds, Neovim closes that window rather than picking a
-- replacement -- and with nvim-tree open the tree is then the last window
-- standing, which trips the rule in core/autocommands.lua that quits Neovim.
-- Closing a buffer took the whole editor down with it. So every window showing
-- the buffer is moved off it first, and only then is the buffer deleted.

-- What a window showing `bufnr` should display instead: the neighbour in the
-- tabline's own order, so closing follows the row of buffers the user is
-- looking at, then the window's alternate, then anything else that is listed.
local function replacement_buffer(bufnr)
	for index, buf in ipairs(vim.t.bufs or {}) do
		if buf == bufnr then
			local neighbour = vim.t.bufs[index + 1] or vim.t.bufs[index - 1]

			if neighbour and vim.api.nvim_buf_is_valid(neighbour) then
				return neighbour
			end
		end
	end

	local alternate = vim.fn.bufnr("#")

	if alternate ~= -1 and alternate ~= bufnr and vim.fn.buflisted(alternate) == 1 then
		return alternate
	end

	for _, other in ipairs(vim.api.nvim_list_bufs()) do
		if other ~= bufnr and vim.fn.buflisted(other) == 1 then
			return other
		end
	end
end

local function listed_buffer_count()
	local count = 0

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.fn.buflisted(bufnr) == 1 then
			count = count + 1
		end
	end

	return count
end

---@param bufnr integer
---@param force boolean|nil discard unsaved changes (the user has said so)
local function close_buffer(bufnr, force)
	-- On the way out of the last buffer, land on the dashboard instead of an
	-- empty window.
	if listed_buffer_count() <= 1 and not pcall(vim.cmd, "Nvdash") then
		vim.cmd("enew")
	end

	local replacement = replacement_buffer(bufnr)

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == bufnr then
			vim.api.nvim_win_call(win, function()
				vim.cmd(replacement and ("buffer " .. replacement) or "enew")
			end)
		end
	end

	local ok, err = pcall(vim.api.nvim_buf_delete, bufnr, { force = force == true })

	if not ok then
		vim.notify(tostring(err), vim.log.levels.ERROR)
	end

	vim.cmd("redrawtabline")
end

-- Write `bufnr` and call `on_written` if it got as far as disk. A buffer that
-- has never been saved has no path to write to, so it gets asked for one --
-- the "save as" half of the dialog.
local function write_buffer(bufnr, on_written)
	local function write(path)
		local ok, err = pcall(function()
			vim.api.nvim_buf_call(bufnr, function()
				vim.cmd(path and ("write " .. vim.fn.fnameescape(path)) or "write")
			end)
		end)

		if not ok then
			vim.notify(tostring(err), vim.log.levels.ERROR)
			return
		end

		on_written()
	end

	if vim.api.nvim_buf_get_name(bufnr) ~= "" then
		write()
		return
	end

	vim.ui.input({ prompt = "Save as: ", completion = "file" }, function(path)
		if path and path ~= "" then
			write(path)
		end
	end)
end

function M.handle_buffer_close()
	local current_bufnr = vim.api.nvim_get_current_buf()

	-- Nothing to close from a sidebar or the dashboard; those are not buffers the
	-- user opened, and deleting them is how nvim-tree ends up alone in a tab.
	if not vim.bo[current_bufnr].buflisted then
		return
	end

	if not vim.bo[current_bufnr].modified then
		close_buffer(current_bufnr)
		return
	end

	local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(current_bufnr), ":t")
	local choices = { "Save and close", "Close without saving", "Cancel" }

	vim.ui.select(choices, {
		prompt = ("%s has unsaved changes"):format(name ~= "" and name or "This buffer"),
	}, function(_, index)
		if index == 1 then
			write_buffer(current_bufnr, function()
				close_buffer(current_bufnr)
			end)
		elseif index == 2 then
			close_buffer(current_bufnr, true)
		end
	end)
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

function M.run_code()
  local file_extension = vim.fn.expand "%:e"
  local selected_cmd = ""
  local term_cmd = "bot 10 new | term "
  local supported_filetypes = {
    c = {
      default = "gcc % -o $fileBase && $fileBase",
      debug = "gcc -g % -o $fileBase && $fileBase",
    },
    cpp = {
      default = "g++ % -o  $fileBase && $fileBase",
      debug = "g++ -g % -o  $fileBase",
      -- competitive = "g++ -std=c++17 -Wall -DAL -O2 % -o $fileBase && $fileBase<input.txt",
      competitive = "g++ -std=c++17 -Wall -DAL -O2 % -o $fileBase && $fileBase",
    },
    cs = {
      default = "dotnet run",
    },
    go = {
      default = "go run %",
    },
    html = {
      default = "firefox %", -- NOTE: Change this based on your browser that you use
    },
    java = {
      default = "java %",
    },
    jl = {
      default = "julia %",
    },
    js = {
      default = "node %",
      debug = "node --inspect %",
    },
    lua = {
      default = "lua %",
    },
    php = {
      default = "php %",
    },
    pl = {
      default = "perl %",
    },
    py = {
      default = "python3 %",
    },
    r = {
      default = "Rscript %",
    },
    rb = {
      default = "ruby %",
    },
    rs = {
      default = "rustc % && $fileBase",
    },
    ts = {
      default = "tsc % && node $fileBase",
    },
  }

  if supported_filetypes[file_extension] then
    local choices = vim.tbl_keys(supported_filetypes[file_extension])

    if #choices == 0 then
      vim.notify("It doesn't contain any command", vim.log.levels.WARN, { title = "Code Runner" })
    elseif #choices == 1 then
      selected_cmd = supported_filetypes[file_extension][choices[1]]
      vim.cmd(term_cmd .. substitute(selected_cmd))
    else
      vim.ui.select(choices, { prompt = "Choose a command: " }, function(choice)
        selected_cmd = supported_filetypes[file_extension][choice]
        if selected_cmd then
          vim.cmd(term_cmd .. substitute(selected_cmd))
        end
      end)
    end
  else
    vim.notify("The filetype isn't included in the list", vim.log.levels.WARN, { title = "Code Runner" })
  end
end

return M

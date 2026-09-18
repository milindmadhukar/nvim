-- Confirmation in front of anything that would close Neovim outright.
--
-- A quit cannot be vetoed once it is under way: QuitPre and ExitPre both fire
-- after the decision is made, and throwing from them still exits. So the
-- confirmation has to sit in front of the things that *start* a quit -- the
-- :q family and ZZ/ZQ (wired up in core/mappings.lua), <leader>q (whichkey),
-- the dashboard's quit button, and the "nvim-tree is the last window" rule in
-- core/autocommands.lua.
--
-- Closing a split, a tab or a float is left alone; only a real exit asks.
-- The dialog is vim.ui.select, so it is drawn by whatever the config points
-- that at (snacks) and matches every other prompt in the editor.

local M = {}

-- True from the moment a dialog opens until its answer has been acted on.
-- vim.ui.select is asynchronous, so this is what stops a second <leader>q --
-- or the nvim-tree rule firing as the dialog closes -- from stacking prompts.
local prompt_open = false

-- Windows holding something the user works in. Floats -- pickers, menus,
-- floaterm, the dialog itself -- are not part of the layout: closing the last
-- one leaves the editor perfectly usable, and `winnr('$')` counting them is
-- what made dismissing a float over a lone nvim-tree quit Neovim.
local function layout_windows()
	local wins = {}

	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_config(win).relative == "" then
			table.insert(wins, win)
		end
	end

	return wins
end

-- Buffers with unsaved changes worth warning about. Scratch and plugin buffers
-- carry no file, so losing them costs nothing.
local function unsaved_buffers()
	local unsaved = {}

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified and vim.bo[buf].buftype == "" then
			table.insert(unsaved, buf)
		end
	end

	return unsaved
end

---Whether quitting the current window would take the whole editor with it.
function M.would_exit()
	if #vim.api.nvim_list_tabpages() > 1 then
		return false
	end

	-- Quitting a float closes the float, never the editor.
	if vim.api.nvim_win_get_config(0).relative ~= "" then
		return false
	end

	return #layout_windows() <= 1
end

---Whether a confirmation dialog is currently waiting on an answer.
function M.is_prompting()
	return prompt_open
end

---Ask before running `cmd`, offering to save when anything is unsaved.
---@param cmd string|nil command to run once confirmed (defaults to `qall`)
---@param opts table|nil `on_cancel` runs when the user backs out
function M.confirm(cmd, opts)
	cmd = cmd or "qall"
	opts = opts or {}

	if prompt_open then
		return
	end

	local unsaved = unsaved_buffers()
	local prompt, choices, actions

	if #unsaved > 0 then
		prompt = ("%d buffer%s unsaved changes. Quit Neovim?"):format(
			#unsaved,
			#unsaved == 1 and " has" or "s have"
		)
		choices = { "Save all and quit", "Quit without saving", "Cancel" }
		actions = {
			function()
				vim.cmd("wall")
				vim.cmd(cmd)
			end,
			function()
				vim.cmd(cmd .. "!")
			end,
		}
	else
		prompt = "Quit Neovim?"
		choices = { "Quit", "Cancel" }
		actions = {
			function()
				vim.cmd(cmd .. "!")
			end,
		}
	end

	prompt_open = true

	vim.ui.select(choices, { prompt = prompt }, function(_, index)
		-- The dialog window is already gone by the time this runs, so anything
		-- watching for it to close -- the nvim-tree rule especially -- has to be
		-- told the answer before `prompt_open` is cleared.
		if index and actions[index] then
			actions[index]()
		elseif opts.on_cancel then
			opts.on_cancel()
		end

		prompt_open = false
	end)
end

---Run `cmd`, asking first if it would close the editor. Closing a split, a tab
---or a float goes through untouched, as does an explicit `!`.
---@param cmd string
function M.request(cmd)
	if prompt_open then
		return
	end

	if cmd:sub(-1) == "!" or not M.would_exit() then
		vim.cmd(cmd)
		return
	end

	M.confirm(cmd)
end

return M

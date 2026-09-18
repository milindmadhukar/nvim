-- NOTE: Maybce some useless mappings that are conflicting
-- require "nvchad.mappings"

local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

local term_opts = { noremap = true, silent = true }

keymap("", "<C-f>", ":silent !tmux neww tmux-sessionizer<CR>", opts)

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Try to use your arrows keys KEKW
-- keymap('', '<up>', '<nop>', opts)
-- keymap('', '<down>', '<nop>')
-- keymap('', '<left>', '<nop>')
-- keymap('', '<right>', '<nop>')

keymap("n", "<up>", ":resize +2<CR>", opts)
keymap("n", "<down>", ":resize -2<CR>", opts)
keymap("n", "<left>", ":vertical resize -2<CR>", opts)
keymap("n", "<right>", ":vertical resize +2<CR>", opts)

-- Resize with arrows
keymap("n", "<A-Up>", ":resize -2<CR>", opts)
keymap("n", "<A-Down>", ":resize +2<CR>", opts)
keymap("n", "<A-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<A-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Center screen when moving vertically
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Center screen when search result is shown
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)
keymap("x", "<leader>p", '"_dP')

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)


-- References --
-- vim-illuminate bound these to its next/prev reference; snacks.words walks
-- the same LSP document highlights.
keymap("n", "<A-n>", function()
	Snacks.words.jump(1, true)
end, { silent = true, desc = "Next reference" })

keymap("n", "<A-p>", function()
	Snacks.words.jump(-1, true)
end, { silent = true, desc = "Previous reference" })

-- Quitting --
-- Every route out of the editor goes past a confirmation first; closing a
-- split, a tab or a float still happens instantly, and an explicit `!` still
-- means "do not ask me". See utils/quit.lua.
vim.api.nvim_create_user_command("Quit", function(o)
	require("utils.quit").request(o.args)
end, { nargs = 1, desc = "Quit, confirming first when it would close Neovim" })

-- `:q` and friends type-expand into the command above. The guard keeps the
-- abbreviation to the start of a real `:` command, so `:g/quit/d` and the like
-- are untouched.
local function quit_abbrev(lhs, cmd)
	vim.cmd(
		string.format(
			"cnoreabbrev <expr> %s (getcmdtype() == ':' && getcmdpos() == %d) ? 'Quit %s' : '%s'",
			lhs,
			#lhs + 1,
			cmd,
			lhs
		)
	)
end

quit_abbrev("q", "quit")
quit_abbrev("quit", "quit")
quit_abbrev("qa", "qall")
quit_abbrev("qall", "qall")
quit_abbrev("quita", "qall")
quit_abbrev("quitall", "qall")
quit_abbrev("wq", "wq")
quit_abbrev("wqa", "wqall")
quit_abbrev("wqall", "wqall")
quit_abbrev("x", "xit")
quit_abbrev("xa", "xall")
quit_abbrev("xall", "xall")

keymap("n", "ZZ", function()
	require("utils.quit").request("xit")
end, opts)

keymap("n", "ZQ", function()
	require("utils.quit").request("quit")
end, opts)

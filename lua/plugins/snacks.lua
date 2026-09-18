-- Replaces dressing.nvim (archived in 2025, its README points here), plus
-- zen-mode.nvim, nvim-notify, vim-illuminate and NvChad's indent-blankline --
-- snacks ships all four as modules, so they come from one plugin now instead
-- of five.
--
-- Deliberately NOT taken over: telescope (fzf-native, smart_history and the
-- projects extension all live there), nvim-tree, nvdash and floaterm. Those
-- are choices this config made on purpose; snacks only fills the gaps.
local M = {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
}

-- Floats have to sit above floaterm, whose windows open at zindex 100. The
-- nvim_open_win default is 50, which is why renaming a terminal used to draw
-- the prompt *behind* the terminal it belonged to.
local ABOVE_FLOATERM = 200

M.opts = {
	-- vim.ui.input. Snacks' own style is a fixed 60-column box pinned near the
	-- top of the editor; these settings keep the box this config has always
	-- had -- at the cursor, 40 columns, rounded, slightly translucent.
	input = {
		enabled = true,
		win = {
			relative = "cursor",
			row = -3,
			col = 0,
			width = 40,
			border = "rounded",
			title_pos = "left",
			zindex = ABOVE_FLOATERM,
			wo = { winblend = 10 },
		},
	},

	-- vim.ui.select. Telescope keeps every picker it is bound to directly; this
	-- is only the generic "pick one of these" prompt. Having a single owner for
	-- it means the dialog looks the same whether or not telescope happens to be
	-- loaded yet -- with two handlers registered, whichever loaded last won.
	-- Picker layouts raise their own zindex above any float already on screen,
	-- so they clear floaterm without being told.
	picker = { enabled = true, ui_select = true },

	-- vim.notify. noice no longer intercepts it (see plugins/noice.lua); the
	-- message filter moved to utils/notify.lua and is reinstalled below.
	notifier = { enabled = true, timeout = 3000 },

	-- Replaces vim-illuminate: highlights the LSP references of whatever is
	-- under the cursor. <A-n>/<A-p> still jump between them (core/mappings).
	words = { enabled = true },

	-- Replaces NvChad's indent-blankline spec, disabled at the bottom of this
	-- file. Adds an animated scope guide that ibl did not have.
	indent = { enabled = true },

	-- Skips syntax, folds and friends on huge files, which is what the
	-- hand-rolled 5000-line check in core/autocommands.lua used to do for
	-- illuminate alone.
	bigfile = { enabled = true },
	quickfile = { enabled = true },

	-- Replaces zen-mode.nvim, keeping its proportions: a 120-column column,
	-- no gutter, and a backdrop that only just darkens the rest.
	zen = {
		toggles = { dim = true, git_signs = false },
		win = {
			width = 120,
			backdrop = { transparent = true, blend = 95 },
			wo = { number = false, relativenumber = false, signcolumn = "no" },
		},
	},
}

function M.config(_, opts)
	require("snacks").setup(opts)

	-- snacks claims vim.notify on UIEnter, so the filter has to wrap whatever
	-- ends up owning it -- registered after setup, it runs after snacks' own
	-- UIEnter handler. When the UI is already up (a reload), install now.
	if vim.v.vim_did_enter == 1 then
		require("utils.notify").install()
	else
		vim.api.nvim_create_autocmd("UIEnter", {
			once = true,
			callback = function()
				require("utils.notify").install()
			end,
		})
	end

	-- Renaming a file in nvim-tree tells the language servers about it, so
	-- imports follow the file instead of silently breaking.
	vim.api.nvim_create_autocmd("User", {
		pattern = "NvimTreeSetup",
		callback = function()
			local events = require("nvim-tree.api").events
			events.subscribe(events.Event.NodeRenamed, function(data)
				Snacks.rename.on_rename_file(data.old_name, data.new_name)
			end)
		end,
	})
end

return {
	M,
	-- NvChad pulls this in itself (NvChad/lua/nvchad/plugins/init.lua); snacks
	-- draws the guides now.
	{ "lukas-reineke/indent-blankline.nvim", enabled = false },
}

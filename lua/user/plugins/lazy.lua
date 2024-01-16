local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = LAZY_PLUGIN_SPEC,
	install = { colorscheme = { "tokyonight-moon" } },
	checker = { enabled = true, notify = false },
	ui = {
		border = "rounded",
	},
	change_detection = {
		enabled = true,
		notify = false,
	},

	dev = {
		-- directory where you store your local plugin projects
		path = "/home/milind/Desktop/Code/NeovimPlugins",
		---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
		patterns = {}, -- For example {"folke"}
		fallback = false, -- Fallback to git when local plugin doesn't exist
	},
})

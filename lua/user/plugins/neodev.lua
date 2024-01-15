local status_ok, neodev = pcall(require, "neodev")
if not status_ok then
	vim.notify("Neodev not found", vim.log.levels.ERROR)
	return
end

neodev.setup({})

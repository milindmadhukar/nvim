local status_ok, neogen = pcall(require, "neogen")
if not status_ok then
	return
end
neogen.setup({
  enabled = true,             --if you want to disable Neogen
  input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
})

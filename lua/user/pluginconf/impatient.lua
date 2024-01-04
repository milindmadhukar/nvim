local status_ok, impatient = pcall(require, "impatient")
if not status_ok then
  vim.notify("Impatient not found", vim.log.levels.ERROR)
  return
end

impatient.enable_profile()

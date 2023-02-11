local status_ok, spotify = pcall(require, "nvim-spotify")
if not status_ok then
  vim.notify("Spotify not found", "error")
  return
end

spotify.setup {
  -- default opts
  status = {
    update_interval = 10000, -- the interval (ms) to check for what's currently playing
    format = "%s %t by %a", -- spotify-tui --format argument
  },
}

if not vim.g.neovide then
  return
end

-- NOTE: Neovide
--
-- Written against Neovide 0.16 (https://neovide.dev/configuration.html).
-- Startup-only settings -- vsync, box drawing, window frame -- cannot be set
-- from Lua and live in ~/.config/neovide/config.toml instead.

-- colorscheme is driven by NvChad base46 (see lua/chadrc.lua)

-- Matched to Ghostty, which is the reference: `font-size = 12` with the default
-- family, which `ghostty +show-face` resolves to JetBrains Mono -- the same
-- typeface this is, Nerd Font patched. Both are points on a scale-1 display, so
-- 12 here is 12 there.
--
-- This used to be h14 with `neovide_scale_factor = 0.75`, which multiply: the
-- text was really 10.5pt, ~12% smaller than the terminal. The scale factor is
-- pinned to 1.0 below instead, so this is the size you get and there is one
-- number to compare against `font-size`.
vim.o.guifont = "JetBrainsMono Nerd Font:h12"

-- Zoom -----------------------------------------------------------------

-- Neovide ships no zoom bindings of its own: `<C-=>` and `<C-->` do nothing
-- until the config maps them, which is why they appeared dead.
--
-- `neovide_scale_factor` is the runtime setting for this
-- (https://neovide.dev/configuration.html#scale-factor) -- Neovide re-reads
-- the global and redraws the moment it changes, so assigning to it *is* the
-- whole mechanism. It multiplies the size in `guifont` above and scales the
-- whole UI with it, so the number in `guifont` stays the real configured size
-- and zoom is a temporary multiplier on top, which `<C-0>` puts back to 1.0.
vim.g.neovide_scale_factor = 1.0

-- 10% per step, multiplicative, so zooming in and back out lands where it
-- started. The bounds keep the window from a font too small to read or one
-- glyph wide.
local SCALE_STEP = 1.1
local SCALE_MIN = 0.4
local SCALE_MAX = 4.0

local function scale(factor)
  local current = vim.g.neovide_scale_factor or 1.0
  local wanted = math.min(SCALE_MAX, math.max(SCALE_MIN, current * factor))

  -- Rounded to a sane number of decimals: repeated multiplication otherwise
  -- drifts into 1.2100000000000002, which is what the notification shows.
  vim.g.neovide_scale_factor = math.floor(wanted * 1000 + 0.5) / 1000
end

---Show the size the window is actually rendering at: the configured point
---size times the scale factor, which is what you would set `guifont` to for
---the same result.
local function report()
  local factor = vim.g.neovide_scale_factor or 1.0
  local points = tonumber(vim.o.guifont:match ":h([%d%.]+)")
  local size = points and ("%.1fpt"):format(points * factor) or vim.o.guifont
  vim.notify(("%s  (%d%%)"):format(size, math.floor(factor * 100 + 0.5)), vim.log.levels.INFO)
end

-- Every mode that can have the cursor in the window, Terminal-mode included:
-- zoom belongs to the window, not to what you happen to be doing in it, and
-- floaterm is exactly where you want it. `<C-=>`, `<C-->` and `<C-0>` are all
-- unused by Neovim and by readline, so nothing is shadowed.
--
-- These reach us only because Neovide is a GUI and sends the real key: a
-- terminal cannot encode Ctrl with `=`, `-` or `0`, which is why this whole
-- section is inside the `vim.g.neovide` guard at the top of the file.
local modes = { "n", "i", "v", "x", "s", "o", "c", "t" }

local function zoom(lhs, factor, desc)
  vim.keymap.set(modes, lhs, function()
    scale(factor)
    report()
  end, { silent = true, desc = desc })
end

zoom("<C-=>", SCALE_STEP, "Zoom in")
-- Ctrl+Shift+= on the same physical key, i.e. reaching for "zoom in" without
-- letting go of shift.
zoom("<C-+>", SCALE_STEP, "Zoom in")
zoom("<C-->", 1 / SCALE_STEP, "Zoom out")
-- Ctrl+wheel, as the rest of the desktop does it.
zoom("<C-ScrollWheelUp>", SCALE_STEP, "Zoom in")
zoom("<C-ScrollWheelDown>", 1 / SCALE_STEP, "Zoom out")

vim.keymap.set(modes, "<C-0>", function()
  vim.g.neovide_scale_factor = 1.0
  report()
end, { silent = true, desc = "Reset zoom" })

vim.api.nvim_create_user_command("NeovideZoom", function(args)
  if args.args == "" then
    report()
    return
  end

  local factor = tonumber(args.args)
  if not factor then
    vim.notify(("not a scale factor: %s"):format(args.args), vim.log.levels.ERROR)
    return
  end

  -- Absolute, unlike the keymaps: `:NeovideZoom 1.5` means 150%, not 1.5x
  -- whatever it is now.
  vim.g.neovide_scale_factor = 1.0
  scale(factor)
  report()
end, {
  nargs = "?",
  desc = "Show the Neovide zoom level, or set it (`:NeovideZoom 1.5`)",
})

-- Window ---------------------------------------------------------------

-- 1.0, i.e. leave it alone, because Hyprland is already doing this to every
-- window: hypr/modules/appearance.lua sets `active_opacity = 0.95`. At 0.9 on
-- top of that Neovide rendered at 0.95 x 0.9 = 0.855 while Ghostty -- which
-- sets `background-opacity = 1` and takes only the compositor's 0.95 -- did
-- not, so every colour in the editor sat a shade further toward the wallpaper.
-- Catppuccin Mocha's #1e1e2e background is identical on both sides
-- (chadrc.lua, and Ghostty's `theme = Catppuccin Mocha`); this is what stopped
-- it looking that way. Turn the fade up here only if you also want Neovide
-- more transparent than the rest of the desktop.
--
-- `neovide_transparency` was the pre-0.13 name and still works as a deprecated
-- alias. `neovide_normal_opacity` fades *only* the Normal background and
-- leaves other highlights opaque.
vim.g.neovide_opacity = 1.0

vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0

-- "dark", not "auto": auto follows the system colour scheme and flips
-- `vim.o.background` with it, but the colorscheme is pinned to
-- catppuccin-mocha either way (plugins/colorschemes.lua), so a light system
-- theme only ever produced a mismatch between the two.
vim.g.neovide_theme = "dark"

-- `neovide_window_blurred` and `neovide_show_border` are macOS-only, so they
-- were no-ops here; on Hyprland the window blur comes from the compositor's
-- own blur rules.
--
-- Floating-window blur, on the other hand, is real work: it blurs everything
-- behind the float on every frame, and floaterm covers ~90% of the window, so
-- it is the most expensive thing on screen while typing into a terminal. 0
-- turns the pass off; the drop shadow still separates the float from the text.
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
vim.g.neovide_floating_shadow = true

-- Refresh --------------------------------------------------------------

-- Matches eDP-2 (1920x1080@144). A value above the display's actual refresh
-- rate only burns GPU; below it makes everything feel choppy.
vim.g.neovide_refresh_rate = 144
-- Applies when the *window is unfocused*, not when you stop typing.
vim.g.neovide_refresh_rate_idle = 5

-- Animation ------------------------------------------------------------

-- Cursor moves of one or two cells -- i.e. typing -- use the *short* animation
-- length. Zero makes typed characters land under the cursor immediately, while
-- jumps (search, `G`, window switches) keep the animation that makes them
-- readable. This is the setting that matters for perceived input latency.
vim.g.neovide_cursor_short_animation_length = 0.0
vim.g.neovide_cursor_animation_length = 0.08
vim.g.neovide_cursor_trail_size = 0.5
vim.g.neovide_cursor_antialiasing = true
-- Insert mode types character by character; animating it just adds a trail.
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_cursor_animate_command_line = true

vim.g.neovide_cursor_vfx_mode = "pixiedust"

vim.g.neovide_position_animation_length = 0.15
-- 0.3 is long enough that fast terminal output visibly lags behind the shell.
vim.g.neovide_scroll_animation_length = 0.15
vim.g.neovide_scroll_animation_far_lines = 1

-- Input ----------------------------------------------------------------

-- This was set twice, false and then true; true is what actually applied.
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_confirm_quit = true
-- "prompt" (the default) asks whether to quit or detach when the window is
-- closed while Neovim is still running; "always_quit"/"always_detach" skip it.
vim.g.neovide_detach_on_quit = "prompt"

-- Terminal buffers -----------------------------------------------------

-- Every keystroke in a terminal moves the cursor and most of them scroll the
-- window, so cursor animation, the particle effects and the scroll animation
-- all run continuously and the shell reads as a beat behind the keyboard.
-- Neovide picks these globals up live, so drop them for the duration of
-- Terminal-mode and put them back on the way out.
local animation = {
  neovide_cursor_animation_length = 0.0,
  neovide_cursor_short_animation_length = 0.0,
  neovide_cursor_trail_size = 0.0,
  neovide_cursor_vfx_mode = "",
  neovide_scroll_animation_length = 0.0,
}

local saved = {}
local group = vim.api.nvim_create_augroup("NeovideTerminalAnimation", { clear = true })

vim.api.nvim_create_autocmd("TermEnter", {
  group = group,
  desc = "Disable Neovide animations in Terminal-mode",
  callback = function()
    for name, value in pairs(animation) do
      if saved[name] == nil then
        saved[name] = vim.g[name]
      end
      vim.g[name] = value
    end
  end,
})

vim.api.nvim_create_autocmd("TermLeave", {
  group = group,
  desc = "Restore Neovide animations when leaving Terminal-mode",
  callback = function()
    for name, value in pairs(saved) do
      vim.g[name] = value
    end
    saved = {}
  end,
})

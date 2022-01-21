local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

--   git add
--   git mod
--   git remove
--   git ignore
--   git rename
--   error
--   info
--   question
--   warning
--   lightbulb

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = true,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  colored = true,
  cond = hide_in_width
}

local status = {
  ["NORMAL"]  = "am very normal :)",
  ["INSERT"]  = " inserting shit  ",
  ["COMMAND"] = " i command thee  ",
  ["VISUAL"]  = "   soo visual    ",
  ["V-LINE"]  = "very visual line ",
  ["V-BLOCK"] = "very visual block",
  ["REPLACE"] = " replacing stuff ",
  ["SELECT"]  = " selecting stuff ",
}

local mode = {
    "mode",
    fmt = function(mode)
          -- local status_val = status[mode]
          -- if status_val == nil then
          --   return mode
          -- end
          return status[mode]
     end,
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local location = {
	"location",
	padding = 0,
}


-- cool function for progress
local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

local spaces = function()
	return "Spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

-- local spotify_status = require'nvim-spotify'.status
-- spotify_status:start()
--
-- local now_playing = function()
--   local np = spotify_status.listen()
--   if np == "" then
--     return ""
--   end
--   local value = string.sub(np, 4)
--   if string.len(np) >= 50 then
--     value = string.sub(value, 0, 50) .. "..."
--   end
--   return "阮" .. value
-- end

lualine.setup {
	options = {
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
		icons_enabled = true,
		theme = "tokyonight",
		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline", "toggleterm" },
		always_divide_middle = true,
	},
	sections = {
    lualine_a = { mode },
    lualine_b = { branch, diagnostics },
    -- lualine_c = { now_playing },
    lualine_c = { "filename" },
    -- lualine_x = { diff }, -- , spaces}, -- , "encoding", "fileformat", filetype},
    lualine_x = { diff , spaces , "encoding", "fileformat", filetype},
    lualine_y = { progress },
    lualine_z = { location },
	},
	inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
	},
	tabline = {},
	extensions = {},
}


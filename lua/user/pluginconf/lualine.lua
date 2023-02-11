local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local status = {
  ["NORMAL"] = "am very normal :)",
  ["INSERT"] = " inserting shit  ",
  ["COMMAND"] = " i command thee  ",
  ["VISUAL"] = "   soo visual    ",
  ["V-LINE"] = "very visual line ",
  ["V-BLOCK"] = "very visual block",
  ["REPLACE"] = " replacing stuff ",
  ["SELECT"] = " selecting stuff ",
}

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
  colored = true,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width,
}

local mode = {
  "mode",
  fmt = function(mode)
    return status[mode]
  end,
  separator = { left = "" },
  right_padding = 2,
}

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
}

local branch = {
  "branch",
  icons_enabled = true,
  colored = true,
  icon = "",
}

local location = {
  "location",
  padding = 0,
  separator = { right = "" },
  left_padding = 2,
}
-- cool function for progress
local progress = function()
  local current_line = vim.fn.line "."
  local total_lines = vim.fn.line "$"
  local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local lsp_client = function()
  local msg = "No Active Lsp"
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return " " .. client.name
    end
  end
  return msg
end

lualine.setup {
  options = {
    component_separators = "|",
    section_separators = { left = "", right = "" },
    icons_enabled = true,
    disabled_filetypes = { "alpha", "dashboard", "Outline" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { mode },
    lualine_b = { branch, diagnostics },
    lualine_c = { "filename" },
    -- lualine_x = { diff }, -- , spaces}, -- , "encoding", "fileformat", filetype},
    lualine_x = { diff, spaces, lsp_client, filetype },
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
  extensions = { "toggleterm" },
}

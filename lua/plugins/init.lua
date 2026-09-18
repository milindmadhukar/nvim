-- NOTE: Default Plugins
return {
  -- NvChad's old standalone terminal plugin. Archived upstream in 2024 -- v2.5
  -- folded the same manager into the UI plugin as `nvchad.term`, which is what
  -- utils/term.lua drives -- so the plugin itself stays off.
  {
    "NvChad/nvterm",
    enabled = false,
  },
}

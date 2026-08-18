-- NOTE: In-buffer markdown rendering.
-- markview.nvim and markdown-preview.nvim were removed: markview fought
-- render-markdown over the same buffers, and markdown-preview's npm build
-- step has been broken since 2023. :Glow (see extras.lua) covers previewing.
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "md" },
  dependencies = { "nvim-mini/mini.nvim" },
  opts = {},
}

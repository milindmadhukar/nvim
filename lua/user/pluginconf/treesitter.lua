local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  vim.notify("Treesitter not found", "error")
  return
end

configs.setup {
  -- ensure_installed = "all", -- one of "all" or a list of languages
  ensure_installed = {
    "javascript",
    "typescript",
    "go",
    "python",
    "c",
    "cpp",
    "dockerfile",
    "rust",
    "lua",
    "cmake",
    "markdown",
    "bash",
    "html",
    "css",
  },
  ignore_install = { "" }, -- List of parsers to ignore installing
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  highlight = {
    enable = true, -- false will disable the whole extension
    additional_vim_regex_highlighting = false,
    disable = { "css" }, -- list of language that will be disabled
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true, disable = { "python", "css" } },
  autotag = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
    config = {
      -- Languages that have a single comment style
      typescript = "// %s",
      css = "/* %s */",
      scss = "/* %s */",
      html = "<!-- %s -->",
      svelte = "<!-- %s -->",
      vue = "<!-- %s -->",
      json = "",
    },
  },
}

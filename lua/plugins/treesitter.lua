-- NOTE: Treesitter
--
-- nvim-treesitter's `master` branch is archived and `main` is now the default.
-- `main` has no module system: there is no `highlight`/`indent`/`ensure_installed`
-- option table any more, so parsers are installed explicitly and highlighting is
-- started from a FileType autocmd. Requires the `tree-sitter` CLI to build parsers.
local parsers = {
  "bash",
  "c",
  "cmake",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "git_config",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "html",
  "java",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "printf",
  "python",
  "query",
  "regex",
  "ron",
  "rust",
  "sql",
  "templ",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSUpdate", "TSLog" },
  config = function()
    require("nvim-treesitter").setup {}

    -- Install anything missing in the background on first launch.
    local installed = require("nvim-treesitter.config").get_installed "parsers"
    local have = {}
    for _, p in ipairs(installed) do
      have[p] = true
    end

    local missing = vim.tbl_filter(function(p)
      return not have[p]
    end, parsers)

    if #missing > 0 then
      require("nvim-treesitter").install(missing)
    end

    -- `main` does not start highlighting for you.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if not lang or not vim.treesitter.language.add(lang) then
          return
        end

        pcall(vim.treesitter.start, ev.buf, lang)

        -- Treesitter-based folds and indent, where the parser supports them.
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        if vim.treesitter.query.get(lang, "indents") then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}

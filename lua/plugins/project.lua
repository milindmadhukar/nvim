-- NOTE: Project detection / "Find Project"
--
-- The nvdash button ran `Telescope projects`, but nothing in this config ever
-- provided that picker -- telescope has no builtin by that name, it comes from
-- project.nvim's extension. The original ahmedkhalf/project.nvim has had no
-- commits since 2023; DrKJeff16/project.nvim is the maintained fork and the one
-- that still works on nvim 0.11+.
--
-- Its option table is NOT the one every old blog post shows: `detection_methods`
-- and `datapath` are gone. Detection is now `lsp.enabled` plus `patterns`, and
-- the recent-project list lives under `history`.
--
-- Loaded on VeryLazy rather than alongside telescope on purpose: the recent
-- list is built from the buffers you open, so it has to already be running
-- before you ask for the picker, not because of it.
return {
  "DrKJeff16/project.nvim",
  event = "VeryLazy",
  opts = {
    -- Ask the attached LSP for the root first, fall back to the markers below.
    --
    -- no_fallback matters in workspaces/monorepos. Pattern detection walks UP
    -- from the file and stops at the FIRST directory holding any marker, so in
    -- a cargo workspace crates/foo/src/main.rs matches crates/foo/Cargo.toml
    -- long before the repo's .git -- and when the two methods disagree,
    -- get_project_root() prefers the *pattern* root. Every crate then becomes
    -- its own "project" and scope_chdir jumps into it. Same trap waits in a
    -- go.work, a pnpm monorepo, or a multi-module pom.xml.
    --
    -- The language servers already answer this correctly (rust-analyzer reports
    -- the workspace root, gopls the module root), so let the LSP win when it
    -- has an opinion; patterns still apply for buffers with no client attached.
    lsp = { enabled = true, no_fallback = true },

    -- Setting this REPLACES the plugin's defaults rather than extending them,
    -- so the VCS markers have to be repeated here.
    patterns = {
      ".git",
      ".github",
      ".hg",
      ".svn",
      ".nvim.lua",
      "Makefile",
      "CMakeLists.txt",
      "package.json",
      "go.mod",
      "Cargo.toml",
      "pyproject.toml",
      "Pipfile",
      "requirements.txt",
      "pom.xml",
      "build.gradle",
    },

    -- Same replace-not-extend rule as `patterns`, so these lists are the
    -- upstream defaults plus the filetypes this config adds (nvdash, oil,
    -- floaterm, trouble).
    disable_on = {
      bt = { "help", "nofile", "nowrite", "terminal" },
      ft = {
        "",
        "NvimTree",
        "TelescopePrompt",
        "TelescopeResults",
        "alpha",
        "checkhealth",
        "floaterm",
        "fzf",
        "lazy",
        "log",
        "mason",
        "notify",
        "nvdash",
        "oil",
        "qf",
        "trouble",
      },
    },

    -- chdir quietly; the statusline and nvim-tree already show where you are.
    silent_chdir = true,
    scope_chdir = "global",
  },
}

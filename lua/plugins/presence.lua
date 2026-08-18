local M = {
  "vyfor/cord.nvim",
  build = ':Cord update',
  event = "VeryLazy",
}

-- stable pseudo-random pick: same seed always yields the same line, so the
-- presence text doesn't flicker every time the cursor moves
local function pick(list, seed)
  local h = 2166136261
  for i = 1, #seed do
    h = (h + seed:byte(i) * i * 131) % 1000003
    h = (h * 31) % 1000003
  end
  return list[h % #list + 1]
end

function M.opts()
  local in_project = {
    "somewhere inside %s",
    "%s, allegedly",
    "pretending to understand %s",
    "%s compiles, that's the win",
    "holding %s together with tape",
    "%s, still standing somehow",
    "%s, one regret per commit",
    "gently ruining %s",
    "%s is my whole personality today",
    "yak shaving in %s",
  }

  local editing = {
    "typing words into %s",
    "%s is my problem now",
    "carefully breaking %s",
    "%s, take 47",
    "adding tomorrow's bugs to %s",
    "renaming things in %s again",
    "%s, refactored beyond recognition",
    "deleting more of %s than i add",
    "%s and a suspicious amount of confidence",
    "writing %s like nobody has to read it",
  }

  local viewing = {
    "staring at %s",
    "reading %s like it's a novel",
    "%s: look, don't touch",
    "scrolling %s hoping it explains itself",
    "%s, read-only, probably for the best",
  }

  return {
    enabled = true,

    editor = {
      client = "neovim",
      tooltip = "neovim, obviously",
    },

    display = {
      theme = "default",
      flavor = "dark",
      view = "full",
      swap_fields = false,
      swap_icons = false,
    },

    timestamp = {
      enabled = true,
      reset_on_idle = false,
      reset_on_change = false,
    },

    idle = {
      enabled = true,
      timeout = 300000, -- 5 minutes
      show_status = true,
      smart_idle = true,
      details = "afk, the code is not fixing itself",
      state = function(opts)
        if not opts.workspace then return "the cursor blinks alone" end
        return string.format("%s waits patiently", opts.workspace)
      end,
      tooltip = "gone to think about what i've done",
    },

    text = {
      workspace = function(opts)
        if not opts.workspace then return "unincorporated territory" end
        return string.format(pick(in_project, opts.workspace), opts.workspace)
      end,

      viewing = function(opts)
        return string.format(pick(viewing, opts.filename), opts.filename)
      end,

      editing = function(opts)
        return string.format(pick(editing, opts.filename), opts.filename)
      end,

      file_browser = function(opts)
        return string.format("browsing %s, forgot what i was looking for", opts.name)
      end,

      plugin_manager = function(opts)
        return string.format("installing plugins instead of writing %s", opts.workspace or "anything real")
      end,

      lsp = function(opts)
        return string.format("losing an argument with %s", opts.name)
      end,

      vcs = function(opts)
        return string.format("writing a commit message that lies about %s", opts.workspace or "all this")
      end,

      debug = function(opts)
        return string.format("print statements everywhere in %s", opts.workspace or "this thing")
      end,

      test = function(opts)
        return string.format("running %s tests and praying", opts.workspace or "the")
      end,

      diagnostics = function(opts)
        return string.format("reading errors i personally added to %s", opts.workspace or "this file")
      end,

      terminal = "in the terminal, up to something",

      dashboard = "opened nvim, that was the whole plan",
    },

    buttons = {
      {
        label = function(opts)
          return opts.repo_url and "the evidence" or "no repo, no proof"
        end,
        url = function(opts)
          return opts.repo_url or "https://github.com"
        end,
      },
    },

    assets = {
      ["init.lua"] = {
        name = "neovim config",
        icon = "lua",
        tooltip = "configuring the editor instead of using it",
        type = "default",
      },
    },

    hooks = {
      post_activity = function(_, activity)
        local version = vim.version()
        activity.assets.small_text = string.format(
          "neovim v%s.%s.%s",
          version.major,
          version.minor,
          version.patch
        )
      end,
    },
  }
end

return M

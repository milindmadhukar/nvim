local M = {
  "vyfor/cord.nvim",
  build = ':Cord update',
  event = "VeryLazy",
}

function M.opts()
  -- Fun quotes that rotate randomly
  local coding_vibes = {
    "🚀 Launching code into orbit",
    "⚡ Channeling big brain energy",
    "🔥 Cooking up some fire code",
    "💎 Crafting digital masterpieces",
    "🌊 Riding the code wave",
    "🎯 Locked in and focused",
    "🧠 Brain.exe is running",
    "✨ Making magic happen",
    "🎨 Painting with pixels",
    "🏗️ Building the future",
  }

  return {
    enabled = true,
    
    editor = {
      client = "neovim",
      tooltip = "The Superior Text Editor",
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
      details = "💤 Taking a well-deserved break",
      state = "Recharging the code batteries",
      tooltip = "AFK - Back soon!",
    },
    
    text = {
      -- Dynamic workspace text with git branch info
      workspace = function(opts)
        if opts.workspace then
          return string.format("🎯 Deep in %s", opts.workspace)
        end
        return "🌟 Crafting code"
      end,
      
      -- Creative viewing text
      viewing = function(opts)
        local hour = tonumber(os.date("%H"))
        local time_emoji = 
          hour >= 22 and "🌙" or
          hour >= 18 and "🌆" or
          hour >= 12 and "☀️" or
          hour >= 5 and "🌅" or
          "🌃"
        
        return string.format("%s Reading %s", time_emoji, opts.filename)
      end,
      
      -- Fancy editing text with cursor position
      editing = function(opts)
        local vibe = coding_vibes[math.random(#coding_vibes)]
        return string.format("✍️ %s", opts.filename)
      end,
      
      file_browser = function(opts)
        return string.format("📁 Exploring files in %s", opts.name)
      end,
      
      plugin_manager = "🔌 Tweaking the plugin arsenal",
      
      lsp = function(opts)
        return string.format("🛠️ Configuring LSP magic in %s", opts.name)
      end,
      
      vcs = function(opts)
        return string.format("📝 Committing greatness in %s", opts.name)
      end,
      
      debug = function(opts)
        return string.format("🐛 Hunting bugs in %s", opts.name)
      end,
      
      test = function(opts)
        return string.format("🧪 Running experiments in %s", opts.name)
      end,
      
      diagnostics = "🔍 Squashing errors like a pro",
      
      terminal = "⚡ Executing commands in the matrix",
      
      dashboard = "🏠 Home sweet home",
    },
    
    -- Dynamic buttons with repository link
    buttons = {
      {
        label = function(opts)
          return opts.repo_url and "📂 View Repository" or "🌐 My Workspace"
        end,
        url = function(opts)
          return opts.repo_url or "https://github.com"
        end,
      },
    },
    
    -- Custom assets for additional file types
    assets = {
      ["init.lua"] = {
        name = "Neovim Config",
        icon = "lua",
        tooltip = "Neovim Configuration",
        type = "default",
      },
    },
    
    -- Hooks for enhanced functionality
    hooks = {
      -- Add Neovim version to small tooltip
      post_activity = function(opts, activity)
        local version = vim.version()
        activity.assets.small_text = string.format(
          "Neovim v%s.%s.%s",
          version.major,
          version.minor,
          version.patch
        )
        
        -- Add random vibe to state when editing
        if not opts.is_idle and vim.bo.modifiable and not vim.bo.readonly then
          activity.state = coding_vibes[math.random(#coding_vibes)]
        end
      end,
      
      -- Custom behavior on workspace change
      workspace_change = function(opts)
        -- You can add custom logic here
        -- For example, notify when switching workspaces
        if opts.workspace then
          vim.notify(string.format("🎯 Switched to workspace: %s", opts.workspace), vim.log.levels.INFO)
        end
      end,
    },
  }
end

return M

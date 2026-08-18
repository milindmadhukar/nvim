-- NOTE: Agentic tooling
--
-- Replaces avante.nvim (which was pinned to a long-superseded model and carried
-- its own API key) with a bridge to the `claude` and `opencode` CLIs already
-- installed on this machine. sidekick drives both from one plugin.
return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  opts = {
    cli = {
      mux = {
        -- Reuse the surrounding multiplexer when there is one, so sessions
        -- survive closing Neovim.
        backend = "tmux",
        enabled = false,
      },
    },
    -- Next Edit Suggestions need the Copilot LSP; off until explicitly enabled.
    nes = { enabled = false },
  },
  keys = {
    { "<leader>a", "", desc = "AI", mode = { "n", "v" } },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      mode = { "n", "v" },
      desc = "Sidekick | Toggle CLI",
    },
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle { name = "claude", focus = true } end,
      mode = { "n", "v" },
      desc = "Sidekick | Claude Code",
    },
    {
      "<leader>ao",
      function() require("sidekick.cli").toggle { name = "opencode", focus = true } end,
      mode = { "n", "v" },
      desc = "Sidekick | opencode",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "v" },
      desc = "Sidekick | Prompt picker",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").send { selection = true } end,
      mode = { "v" },
      desc = "Sidekick | Send selection",
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send { msg = "{file}" } end,
      mode = { "n" },
      desc = "Sidekick | Send file",
    },
  },
}

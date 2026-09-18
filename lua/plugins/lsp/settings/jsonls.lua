-- JSON schemas for jsonls.
--
-- This used to be ~170 lines of hand-maintained schemastore.org URLs. b0o/SchemaStore.nvim
-- vendors the whole catalog and tracks it upstream, so the list is no longer ours to keep
-- current. The plugin is a `dependencies` entry of the lspconfig spec because that spec's
-- config function requires this file synchronously.
--
-- The catalog is built in `before_init` rather than here: this file is required while
-- nvim-lspconfig loads, i.e. on the first buffer of every session, and `schemas()` costs
-- ~4ms to assemble a table that only a JSON buffer will ever use. `before_init` runs when
-- the client actually starts.
--
-- It mutates `config.settings` in place on purpose. vim.lsp.Client copies the *reference*
-- to `config.settings` when it is constructed, which happens before before_init runs, so
-- reassigning `config.settings = {...}` there would leave `client.settings` pointing at
-- the old table and the schemas would never reach the server.
return {
  settings = {
    json = {
      schemas = {},
      validate = { enable = true },
    },
  },
  before_init = function(_, config)
    config.settings.json.schemas = require("schemastore").json.schemas()
  end,
}

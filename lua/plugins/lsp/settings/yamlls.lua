-- YAML schemas for yamlls, from b0o/SchemaStore.nvim.
--
-- yamlls ships its own SchemaStore client, but it only resolves a subset and cannot be
-- combined with explicit schemas. Turning it off and feeding the full catalog through
-- `schemas` keeps json and yaml on the same source.
--
-- See plugins/lsp/settings/jsonls.lua for why the catalog is assembled in `before_init`
-- and why it has to mutate `config.settings` in place.
return {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = {},
    },
  },
  before_init = function(_, config)
    config.settings.yaml.schemas = require("schemastore").yaml.schemas()
  end,
}

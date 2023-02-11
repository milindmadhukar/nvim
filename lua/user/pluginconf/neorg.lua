local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
  vim.notify("Neorg not found", "error")
  return
end

neorg.setup {
  load = {
    ["core.defaults"] = {},
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          work = "~/notes/work",
          home = "~/notes/home",
        },
      },
    },
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
    ["core.export"] = {
      config = {},
    },
    ["core.export.markdown"] = {
      config = {
        extensions = "all",
      },
    },
    ["core.integrations.nvim-cmp"] = {
      config = {},
    },
  },
}

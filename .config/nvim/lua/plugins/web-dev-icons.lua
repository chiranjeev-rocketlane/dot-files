-- File: lua/plugins/icons.lua

return {
  "nvim-tree/nvim-web-devicons",
  config = function()
    local devicons = require "nvim-web-devicons"

    -- This is the setup part
    devicons.setup {
      -- You can override any icon or color here
      override_by_filename = {
        ["docker-compose.yaml"] = {
          icon = "", -- The docker whale icon
          color = "red", -- A red color
          name = "DockerComposeYaml", -- A unique name for the highlight group
        },
        [".dockerignore"] = {
          icon = "",
          color = "black",
          name = "DockerIgnore",
        },
        ["docker-compose.db.yaml"] = {
          icon = "",
          color = "darkorange",
          name = "DockerComposeDBYaml",
        },
        ["docker-compose.dev.yaml"] = {
          icon = "",
          color = "lightgreen",
          name = "DockerComposeDevYaml",
        },
        -- [".yaml"] = {
        --   icon = "",
        --   color = "#e03c3c",
        --   name = "DockerComposeYaml",
        -- },
      },
      -- You can also override by file extension
      override_by_extension = {
        ["log"] = {
          icon = "",
          color = "#c792ea",
          name = "LogFile",
        },
      },
    }
  end,
}

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP completion
      "hrsh7th/cmp-buffer", -- Buffer completion
      "hrsh7th/cmp-path", -- File path completion
      "hrsh7th/cmp-cmdline", -- Command-line completion
      "L3MON4D3/LuaSnip", -- Snippet support
      "saadparwaiz1/cmp_luasnip",
      "github/copilot.vim", --copilot
    },
    event = "InsertEnter",
    config = function()
      local cmp = require "cmp"
      cmp.setup {
        mapping = cmp.mapping.preset.insert {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
        },
      }
    end,
  },
}

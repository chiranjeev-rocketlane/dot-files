-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.utility.hover-nvim" },
  { import = "astrocommunity.scrolling.mini-animate" },
  { import = "astrocommunity.colorscheme.sonokai" },
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  { import = "astrocommunity.colorscheme.eldritch-nvim" },
  -- { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.colorscheme.horizon-nvim" },
  { import = "astrocommunity.colorscheme.aurora" },
  { import = "astrocommunity.colorscheme.oldworld-nvim" },
  {
    import = "astrocommunity.colorscheme.vim-moonfly-colors",
  },
  { import = "astrocommunity.colorscheme.oxocarbon-nvim" },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("rose-pine").setup {
        variant = "moon", -- Start with the moon variant

        -- Disable the default background to apply your override
        disable_background = true,

        highlight_groups = {
          -- Your original overrides
          Normal = { bg = "#111111" },
          NormalNC = { bg = "#111111" },

          -- ADD THESE LINES:

          -- 1. For the cursor line
          CursorLine = { bg = "#121212" },

          -- 2. For the bufferline "tab bar"
          -- This sets the background for the whole bar
          BufferLineFill = { bg = "#111111" },
          -- This sets the background for inactive tabs
          BufferLineBuffer = { bg = "#111111" },
          -- This sets the background for the tab in view, but not focused
          BufferLineBufferVisible = { bg = "#111111" },
          -- This clears the background for the currently selected tab
          BufferLineBufferSelected = { bg = "#111111" },

          -- ADD THESE LINES for the status line (at the bottom)
          StatusLine = { bg = "#111111" },
          StatusLineNC = { bg = "#111111" },

          -- ADD THESE: Winbar (the "Config" bar)
          WinBar = { bg = "#111111" },
          WinBarNC = { bg = "#111111" },

          -- ADD THESE: Fallbacks for the native tabline
          TabLine = { bg = "#111111" }, -- Inactive tab background
          TabLineSel = { bg = "#111111" }, -- Active tab background
          TabLineFill = { bg = "#111111" }, -- The empty space on the tab bar

          -- ADD THESE: For floating windows (Telescope, etc.)
          NormalFloat = { bg = "#111111" },
          FloatBorder = { bg = "#111111" },
          -- Add Telescope-specific groups just in case
          TelescopeNormal = { bg = "#111111" },
          TelescopeBorder = { bg = "#111111" },
          TelescopePromptNormal = { bg = "#111111" },
          TelescopeResultsNormal = { bg = "#111111" },

          -- ADD THESE: For the built-in terminal
          ToggleTermFloat = { bg = "#111111" },
        },
      }
      -- require("rose-pine").load()
      -- vim.cmd "colorscheme rose-pine"
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("github-theme").setup {
        -- ...
      }

      -- vim.cmd "colorscheme github_dark"
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  { "echasnovski/mini.nvim", version = "*" },
  -- Using lazy.nvim
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- require("bamboo").setup {
      -- optional configuration here
      -- }
      -- require("bamboo").load()
    end,
  },
  {
    "thesimonho/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = ... },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
      "nvim-telescope/telescope.nvim",
      -- "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      -- configuration goes here
    },
  },
  -- {
  --   "Kaikacy/Lemons.nvim",
  --   version = "*", -- for stable release
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme "lemons"
  --     -- or
  --     -- require("lemons").load()
  --     -- there is no difference between these two
  --   end,
  -- },
}

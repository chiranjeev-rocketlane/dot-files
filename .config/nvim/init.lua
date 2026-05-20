-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

vim.o.tabstop = 4 -- Number of visual spaces per tab
vim.o.shiftwidth = 4 -- Number of spaces to use for autoindent
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- =========================================================================
-- 🎯 NEOCONF TRANSPARENCY FIX
-- =========================================================================
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Clear background for standard buffers and floating splits
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })

    -- Clear background specifically for Neo-tree file explorer panels
    vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { bg = "none" })
  end,
})

require "lazy_setup"
require "polish"
-- -- Install without configuration
-- { "projekt0n/github-nvim-theme", name = "github-theme" }
-- -- Or with configuration
-- {
--    "projekt0n/github-nvim-theme",
--    name = "github-theme",
--    lazy = false, -- make sure we load this during startup if it is your main colorscheme
--    priority = 1000, -- make sure to load this before all the other start plugins
--    config = function()
--      require("github-theme").setup {
--        -- ...
--      }
--
--      vim.cmd "colorscheme github_dark"
--    end,
-- }

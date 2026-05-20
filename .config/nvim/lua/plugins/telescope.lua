return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    opts.defaults = opts.defaults or {}
    opts.defaults.hidden = true -- Show hidden files
    opts.defaults.file_ignore_patterns = { "%.git/" } -- Still ignore .git directory
  end,
}

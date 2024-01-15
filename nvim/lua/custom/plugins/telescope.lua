-- Telecscope additions
pcall(require("telescope").load_extension, "file_browser")
-- Enable telescope fzy native, if installed
pcall(require('telescope').load_extension, 'fzy')
-- Enable telescope live grep args
pcall(require('telescope').load_extension, 'live_grep_args')
-- Enable telescope-dap
pcall(require('telescope').load_extension, 'nvim-telescope/telescope-dap.nvim')

return {
  -- Much prefer to use fzy native due to fzf being too fuzzy
  'nvim-telescope/telescope-fzy-native.nvim',
  -- Other telescope addons
  'nvim-telescope/telescope-live-grep-args.nvim',
  'nvim-telescope/telescope-file-browser.nvim',
  'nvim-telescope/telescope-dap.nvim',
}

" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Plug
call plug#begin('~/.vim/plugged')
    " Telescope
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-live-grep-args.nvim'
    Plug 'nvim-telescope/telescope-file-browser.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'
    Plug 'nvim-telescope/telescope-rg.nvim'
    Plug 'nvim-telescope/telescope-dap.nvim'

call plug#end()

lua << EOF
require('telescope').setup{}
vim.g.mapleader = ","
vim.opt.termguicolors = false
vim.keymap.set('n', '<leader>fh', "<cmd>Telescope help_tags<CR>", opts)


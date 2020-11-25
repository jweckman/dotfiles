"Basics
syntax on
set rnu
set path +=**
set wildmenu
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set noswapfile
set incsearch
map <F7> gg=G<C-o><C-o>
set ignorecase


" Install Plug if isn't already
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
    Plug 'tpope/vim-surround'
call plug#end()"

" PLUG plugins
call plug#begin('~/.vim.plugged')
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
"Plug 'junegunn/fzf.vim'
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
Plug 'soywod/iris.vim'
call plug#end()

"PLUG plugin mappings and configurations
map <C-n> :NERDTreeToggle<CR>


" Iris plugin for using email in vim
let g:iris_name  = "name"
let g:iris_mail = "email"

"let g:iris_imap_host  = "your.imap.host"
"let g:iris_imap_port  = 993
"let g:iris_imap_login = "Your IMAP login" "Default to g:iris_mail

"let g:iris_smtp_host  = "your.smtp.host" "Default to g:iris_imap_host
"let g:iris_smtp_port  = 587
"let g:iris_smtp_login = "Your IMAP login" "Default to g:iris_mail

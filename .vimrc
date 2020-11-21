"set nonu
set rnu
set path+=**
set wildmenu
syntax on
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set noswapfile
set incsearch


" PLUG
call plug#begin('~/.vim.plugged')
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
"Plug 'junegunn/fzf.vim'
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
Plug 'soywod/iris.vim'
call plug#end()
map <C-n> :NERDTreeToggle<CR>




" IRIS EMAIL
let g:iris_name  = "Joakim"
let g:iris_mail = "joakim.weckman@gmail.com"

"let g:iris_imap_host  = "your.imap.host"
"let g:iris_imap_port  = 993
"let g:iris_imap_login = "Your IMAP login" "Default to g:iris_mail

"let g:iris_smtp_host  = "your.smtp.host" "Default to g:iris_imap_host
"let g:iris_smtp_port  = 587
"let g:iris_smtp_login = "Your IMAP login" "Default to g:iris_mail

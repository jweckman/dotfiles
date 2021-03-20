syntax on
set rnu
set nu rnu
set path +=**
set wildmenu
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set noswapfile
set incsearch
set ignorecase
set updatetime=300
set shortmess+=c
set foldmethod=syntax
set lazyredraw
set foldnestmax=10
set nofoldenable
set foldlevel=2
nnoremap gv <c-v>
map <F7> gg=G<C-o><C-o>


" Install Plug if isn't already
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
    Plug 'tpope/vim-surround'
    Plug 'mechatroner/rainbow_csv'
call plug#end()

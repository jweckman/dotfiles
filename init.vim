syntax on
set rnu
set nu rnu
" Use below setting if no plugins are available. Allows vanilla fuzzy finding
"set path +=**
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
let mapleader=","
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
    Plug 'ap/vim-buftabline'
    " Telescope
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'
    " LSP
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-compe'
call plug#end()

" Telescope configs
nnoremap <leader>ff :lua require('telescope.builtin').find_files{ find_command = {'rg', '--files', '--hidden', '-g', '!*.{xls,xlsx,pdf,rbql}'} }<CR>

" LSP Configs
lua << EOF
require'lspconfig'.pyright.setup{}

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
  };
}

require'lspconfig'.jsonls.setup {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
}

vim.o.completeopt = "menuone,noselect"
EOF

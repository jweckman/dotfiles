syntax on
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
"set foldmethod=syntax
set lazyredraw
set foldnestmax=10
set nofoldenable
set foldlevel=2
let mapleader=","
nnoremap gv <c-v>
set hidden
set list
set listchars=tab:›\ ,trail:⋅
nnoremap <C-L> :bnext<CR>
nnoremap <C-H> :bprev<CR>
map <leader>t :let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>cd $VIM_DIR<CR>
" Try to prettify the builtin way
map <leader>pp gg=G<C-o><C-o>
set clipboard+=unnamedplus
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
nnoremap <leader>cdd :cd %:p:h<CR>:pwd<CR>

" File type specific configs
autocmd FileType xml setlocal expandtab
" Line diff configs. Allows for comparing the @a and @b register contents
noremap <leader>ldt :Linediff<CR>
noremap <leader>ldo :LinediffReset<CR>

let g:diffed_buffers = []

function DiffText(a, b, diffed_buffers)
    enew
    setlocal buftype=nowrite
    call add(a:diffed_buffers, bufnr('%'))
    call setline(1, split(a:a, "\n"))
    diffthis
    vnew
    setlocal buftype=nowrite
    call add(a:diffed_buffers, bufnr('%'))
    call setline(1, split(a:b, "\n"))
    diffthis
endfunction

function WipeOutDiffs(diffed_buffers)
    for buffer in a:diffed_buffers
        execute 'bwipeout! ' . buffer
    endfor
endfunction

nnoremap <leader>ldr :call DiffText(@a, @b, g:diffed_buffers)<CR>
"nnoremap <leader>ldrr :call WipeOutDiffs(g:diffed_buffers) | let g:diffed_buffers=[]<CR>

" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Plug
call plug#begin('~/.vim/plugged')
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-fugitive/'
    Plug 'vim-airline/vim-airline'
    Plug 'mechatroner/rainbow_csv'
    Plug 'vimwiki/vimwiki'
    Plug 'numToStr/Comment.nvim'
    Plug 'theHamsta/nvim-dap-virtual-text'
    " Telescope
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'
    Plug 'nvim-telescope/telescope-rg.nvim'
    Plug 'nvim-telescope/telescope-dap.nvim'
    " Treesitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/playground'
    " LSP
    Plug 'neovim/nvim-lspconfig'
    Plug 'lspcontainers/lspcontainers.nvim'
    "Plug 'hrsh7th/nvim-cmp'
    Plug 'simrat39/rust-tools.nvim'
    Plug 'ray-x/lsp_signature.nvim'
    Plug '/home/joakim/code/odoo.nvim'
    "DAP
    Plug 'mfussenegger/nvim-dap'
    Plug 'mfussenegger/nvim-dap-python'

call plug#end()

" Vim Wiki
let g:vimwiki_list = [{'path': '/rpi2tb/joakim/documents/wiki', 'syntax': 'markdown'}]
au FileType vimwiki setlocal shiftwidth=6 tabstop=6 noexpandtab

" Vim fugitive
nmap <leader>gs :Git<CR>
nmap <leader>gh :diffget //2<CR>
nmap <leader>gl :diffget //3<CR>
nmap <leader>gm :Gdiffsplit!<CR>
nmap <leader>gd :Git diff<CR>

" Telescope configs

nnoremap <leader>fb :lua require('telescope.builtin').file_browser{}<CR>
nnoremap <leader>fbb :lua require('telescope.builtin').file_browser{cwd = '%:h'}<CR>
nnoremap <leader>lb :lua require('telescope.builtin').buffers{}<CR>
nnoremap <leader>ff :lua require('telescope.builtin').find_files{ find_command = {'rg', '--files', '--hidden', '-g', '!*.{xls,xlsx,pdf,rbql,po}'} }<CR>
nnoremap <leader>fd :lua require('telescope.builtin').find_files{search_dirs = {'/home/joakim/.config', '/home/joakim/scripts'} }<CR>
nnoremap <leader>fg  :lua require("telescope").extensions.live_grep_raw.live_grep_raw() 
nnoremap <leader>fgg :lua require('telescope.builtin').live_grep{search_dirs = {'%:h'}}<CR>
nnoremap <leader>fgd :lua require('telescope.builtin').live_grep{search_dirs = {'/home/joakim/.config', '/home/joakim/scripts'}}<CR>
nnoremap <leader>ll :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" LSP and Treesitter configs
lua << EOF

-- LSP signature plugin setup
require "lsp_signature".setup()

-- Languages setup
require'lspconfig'.lemminx.setup{
    cmd = { "/usr/bin/lemminx" };
}
--require'lspconfig'.jedi_language_server.setup{}
require'lspconfig'.pyright.setup{
settings = {
      python = {
        analysis = {
          autoSearchPaths = false,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true
        }
      }
    }
}
require'lspconfig'.texlab.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.jsonls.setup {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
}
require'lspconfig'.tsserver.setup{}
require('lua-ls')
require'lspconfig'.dockerls.setup {
  before_init = function(params)
    params.processId = vim.NIL
  end,
  cmd = require'lspcontainers'.command('dockerls'),
}

require('telescope').setup{
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    --border = {},
    --borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    path_display = {'smart'}, --shorten
  }
}

-- Comment plugin setup
require('Comment').setup()

-- Debugging tool initialization
require('dap-python').setup('~/.venvs/debugpy/bin/python')
require('dap-python').test_runner = 'pytest'


-- LSP global keymaps
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

-- Treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    "python",
    "rust",
    "json",
    "yaml",
    "html",
    "javascript",
  },
}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx", "python" }

vim.o.completeopt = "menuone,noselect"

-- Plugin editing helper functions
P = function(v)
  print(vim.inspect(v))
  return v
end

EOF

nnoremap <silent> <leader>dc :lua require'dap'.continue()<CR>
nnoremap <silent> <leader>dov :lua require'dap'.step_over()<CR>
nnoremap <silent> <leader>dsi :lua require'dap'.step_into()<CR>
nnoremap <silent> <leader>dso :lua require'dap'.step_out()<CR>
nnoremap <silent> <leader>db :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>dsb :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>dlp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
nnoremap <silent> <leader>ds :lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>
nnoremap <silent> <leader>di :lua require'dap.ui.widgets'.hover()<CR>

let g:dap_virtual_text = v:true

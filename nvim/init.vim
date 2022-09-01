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
nnoremap <leader>cfd :cd %:p:h<CR>:pwd<CR>
" Global statusline settings
set laststatus=3
highlight Winseparator guibg=None

" File type specific configs
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType xml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype json setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype yaml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
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
    Plug 'vim-airline/vim-airline'
    Plug 'mechatroner/rainbow_csv'
    Plug 'vimwiki/vimwiki'
    Plug 'numToStr/Comment.nvim'
    Plug 'theHamsta/nvim-dap-virtual-text'
    " Git
    Plug 'tpope/vim-fugitive/'
    Plug 'emmanueltouzery/agitator.nvim'
    Plug 'TimUntersberger/neogit'
    Plug 'sindrets/diffview.nvim'
    " Telescope
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-live-grep-args.nvim'
    Plug 'nvim-telescope/telescope-file-browser.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'
    Plug 'nvim-telescope/telescope-rg.nvim'
    Plug 'nvim-telescope/telescope-dap.nvim'
    " Treesitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/playground'
    Plug 'nvim-treesitter/nvim-treesitter-context'
    " LSP
    Plug 'neovim/nvim-lspconfig'
    Plug 'lspcontainers/lspcontainers.nvim'
    "Plug 'hrsh7th/nvim-cmp'
    Plug 'simrat39/rust-tools.nvim'
    Plug 'ray-x/lsp_signature.nvim'
    Plug '/home/joakim/code/odoo.nvim'
    " DAP
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

" nnoremap <leader>fb :lua require('telescope.builtin').file_browser{}<CR>
" nnoremap <leader>fbb :lua require('telescope.builtin').file_browser{cwd = '%:h'}<CR>
nnoremap <leader>lb :lua require('telescope.builtin').buffers{}<CR>
nnoremap <leader>ff :lua require('telescope.builtin').find_files{ find_command = {'rg', '--files', '--hidden', '-g', '!*.{xls,xlsx,pdf,rbql,po}'} }<CR>
nnoremap <leader>fd :lua require('telescope.builtin').find_files{search_dirs = {'/home/joakim/.config', '/home/joakim/scripts'} }<CR>
nnoremap <leader>fg  :lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>
nnoremap <leader>ll :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" LSP and Treesitter configs
lua << EOF

-- LSP signature plugin setup
require "lsp_signature".setup()

-- Languages setup
require'lspconfig'.lemminx.setup{
    cmd = { "/home/joakim/.local/bin/lemminx" };
}
require'lspconfig'.jedi_language_server.setup{}
--require'lspconfig'.pyright.setup{
--settings = {
--      python = {
--        analysis = {
--          autoSearchPaths = false,
--          diagnosticMode = "workspace",
--          useLibraryCodeForTypes = true
--        }
--      }
--    }
--}
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

-- Telescope general setup
require('telescope').setup{
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.96,
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    --border = {},
    --borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    path_display = {
        'truncate',
        shorten = { len = 3, exclude = {1, -2, -1} }
    },
  },
}

require("telescope").load_extension "file_browser"

vim.api.nvim_set_keymap(
  "n",
  "<leader>fb",
  ":Telescope file_browser<CR>",
  { noremap = true }
)

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

-- Neogit and diffview
local cb = require "diffview.config".diffview_callback
require'diffview'.setup {}

local neogit = require('neogit')
neogit.setup {
    disable_commit_confirmation = true,
    integrations = {
        diffview = true
    }
}

local get_docker_service_ips = function()
    local handle = io.popen("docker ps -q | xargs -n 1 docker inspect --format '{{ .Name }} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' | sed 's#^/##';")
    local service_ip_str = handle:read("*a")
    handle:close()
    local res = {}
    for line in service_ip_str:gmatch("[^\r\n]+") do
        local service_ip = {}
        for w in line:gmatch("%S+") do
            service_ip[#service_ip + 1] = w
        end
        res[service_ip[1]] = service_ip[2]
    end
    return res
end

DAPATTACH = {}

DAPATTACH.attach_python_debugger = function()
    local docker_service_ips = get_docker_service_ips()
    local adapter_config = {
        ['/home/joakim/docker-volumes/data-pydebugdemo'] = {
            docker_service_name = 'debug-python', 
            adapter = {
                host = nil,
                port = '12345'
            },
            remote_root = '/home/joakim/data-pydebugdemo'
        },
        ['/home/joakim/code/odoo15/odoo'] = {
            docker_service_name = 'odoo15', 
            adapter = {
                host = nil,
                port = '12345'
            },
            remote_root = '/odoo'
        }
    }
    local config = nil
    for candidate_parent, conf in pairs(adapter_config) do
        patternized_cp = string.gsub(candidate_parent, '-', '.')
        local is_substr = string.match(vim.fn.getcwd(), patternized_cp)
        if is_substr ~= nil then
            config = conf
        end
    end
    local dap = require "dap"
    docker_service_name = config['docker_service_name']
    local adapter = config['adapter']
    if docker_service_name ~= nil then
        adapter['host'] = docker_service_ips[docker_service_name]
    end
    pythonAttachAdapter = {
        type = "server";
        host = adapter;
        port = tonumber(adapter['port']);
    }
    pythonAttachConfig = {
        type = "python";
        request = "attach";
        connect = {
            port = tonumber(adapter['port']);
            host = host;
        };
        mode = "remote";
        name = "Remote Attached Debugger";
        cwd = vim.fn.getcwd();
        pathMappings = {
            {
                localRoot = vim.fn.getcwd(); -- Wherever your Python code lives locally.
                remoteRoot = config['remote_root']; -- Wherever your Python code lives in the container.
            };
        };
    }
    local session = dap.attach(adapter, pythonAttachConfig)
    if session == nil then
        io.write("Error launching adapter");
    end
    dap.repl.open()
end

-- DAP keybindings
vim.api.nvim_set_keymap('n', '<leader>da', "<cmd>lua DAPATTACH.attach_python_debugger()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>dc', "<cmd>lua require'dap'.continue()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>dov', "<cmd>lua require'dap'.step_over()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>dsi', "<cmd>lua require'dap'.step_into()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>dso', "<cmd>lua require'dap'.step_out()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>db', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>dsb', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>dlp', "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>dr', "<cmd>lua require'dap'.repl_open()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>dl', "<cmd>lua require'dap'.run_last()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>ds', "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>di', "<cmd>lua require'dap.ui.widgets'.hover()<CR>", opts)

-- General keybindings
vim.api.nvim_set_keymap('n', '<leader>cd', "<cmd>lua require'custom_pickers'.common_paths()<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>gg', "<cmd>Neogit<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>gl', "<cmd>Neogit log<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>gp', "<cmd>Neogit push<CR>", opts)
--vim.api.nvim_set_keymap('n', '<leader>gd', "<cmd>DiffviewOpen<CR>", opts)

EOF

let g:dap_virtual_text = v:true


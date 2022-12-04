
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
    Plug 'vim-airline/vim-airline-themes'
    Plug 'mechatroner/rainbow_csv'
    Plug 'vimwiki/vimwiki'
    Plug 'numToStr/Comment.nvim'
    Plug 'theHamsta/nvim-dap-virtual-text'
    Plug 'lambdalisue/nerdfont.vim'
    Plug 'ryanoasis/vim-devicons'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'LunarVim/Colorschemes'
    Plug 'lewis6991/impatient.nvim'
    Plug 'ThePrimeagen/vim-be-good'
    " post install (yarn install | npm install) then load plugin only for editing supported files
    "Plug 'prettier/vim-prettier', {
    "  \ 'do': 'yarn install --frozen-lockfile --production',
    "  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
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

lua << EOF
local opts = {silent=true }
vim.g.mapleader = " "
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.wildmenu = true
vim.opt.errorbells = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.updatetime = 300
vim.opt.shortmess:append("c")
vim.opt.lazyredraw = true
vim.opt.foldnestmax = 10
vim.opt.foldenable = false
vim.opt.foldlevel = 2
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" 
vim.opt.hidden = true
vim.opt.list = true
vim.opt.listchars = "tab:›  ,trail:⋅"
vim.opt.laststatus = 3
vim.opt.clipboard:append("unnamedplus")
vim.keymap.set('n', 'gv', '<c-v>', opts)
vim.keymap.set('n', '<C-L>', '<cmd>bprev<CR>', opts)
vim.keymap.set('n', '<C-H>', '<cmd>bnext<CR>', opts)
vim.keymap.set('n', '<leader>t', '<cmd>tabnew | term<CR>', opts)
vim.keymap.set('n', '<leader>pp', '<cmd>gg=G<C-o><C-o>', opts)
vim.keymap.set('n', '<leader>cfd', '<cmd>cd %:p:h<CR><cmd>pwd<CR>', opts)
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
vim.api.nvim_set_hl(0,"Winseparator", {bg = "None", default = true})
vim.g.airline_theme = 'minimalist'
vim.opt.termguicolors = true

-- Vim Wiki configs
vim.g.vimwiki_list = {
    {
        path = '/home/joakim/wiki/',
        syntax = 'markdown',
        ext = '.md',
    }
}

-- General autocommands

-- Set csv file to csv_semicolon for RainbowCsv highlighting. Use RainbowDelim to set manually to something else
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"csv"},
  command = "set filetype=csv_semicolon",
})

require('colorscheme')
require('impatient')

-- File type specific autocommands
vim.api.nvim_create_autocmd({ "FileType"}, {
  pattern = {"python"},
  command = "setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4",
})
vim.api.nvim_create_autocmd({ "FileType"}, {
  pattern = {"xml"},
  command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType"}, {
  pattern = {"json"},
  command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType"}, {
  pattern = {"yaml"},
  command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType"}, {
  pattern = {"vimwiki"},
  command = "setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4",
})
vim.api.nvim_create_autocmd({ "FileType"}, {
  pattern = {"vue"},
  command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType"}, {
  pattern = {"javascript"},
  command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType"}, {
  pattern = {"typescript"},
  command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})

-- LSP signature plugin setup
require "lsp_signature".setup()

-- Languages setup
require'lspconfig'.lemminx.setup{
    cmd = { "/home/joakim/.local/bin/lemminx" };
}
require'lspconfig'.jedi_language_server.setup{}
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
require'lspconfig'.vuels.setup {
}

-- Telescope general setup
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key"
      }
    },
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.96,
      preview_width = 0.57,
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

vim.keymap.set(
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
vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.keymap.set('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.keymap.set('n', '<leader>sh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
vim.keymap.set('n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
vim.keymap.set('n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
vim.keymap.set('n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
vim.keymap.set('n', '<leader>lD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
vim.keymap.set('n', '<leader>lrn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.keymap.set('n', '<leader>lca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.keymap.set('n', '<leader>le', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.keymap.set('n', '<leader>lq', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
vim.keymap.set('n', '<leader>lf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

-- Telescope keymaps
vim.keymap.set('n', '<leader>ll', "<cmd>lua require'telescope.builtin'.buffers()<CR>", opts)
vim.keymap.set('n', '<leader>fd', "<cmd>lua require'telescope.builtin'.find_files({search_dirs={'/home/joakim/.config','/home/joakim/scripts'}})<CR>", opts)
vim.keymap.set('n', '<leader>ff', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!*.{xls,xlsx,pdf,rbql,po}'}} )<CR>", opts)
vim.keymap.set('n', '<leader>fg', "<cmd>lua require'telescope'.extensions.live_grep_args.live_grep_args()<CR>", opts)
vim.keymap.set('n', '<leader>fh', "<cmd>Telescope help_tags<CR>", opts)
vim.keymap.set('n', '<leader>fr', "<cmd>lua require'telescope.builtin'.resume()<CR>", opts)
vim.keymap.set('n', '<leader>gb', "<cmd>lua require'telescope.builtin'.git_bcommits()<CR>", opts)
vim.keymap.set("n", "<leader>gd", "<cmd>lua require'telescope.builtin'.git_status()<CR>", opts)

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
    "vue",
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

-- Usage: :RegDiff [{register_1} {register_2}]
-- If no registers are supplied: defaults to `+` and `*`.
vim.api.nvim_create_user_command("RegDiff", function(ctx)
  local reg1, reg2

  if #ctx.fargs == 0 then
    -- If no args given: default to + and * registers
    reg1, reg2 = "+", "*"
  elseif #ctx.fargs < 2 then
    vim.notify("Inusfficient number of registers supplied! Needs two.", vim.log.levels.ERROR, {})
    return
  else
    -- Get registers from the given args
    reg1, reg2 = ctx.fargs[1], ctx.fargs[2]
  end

  local reg1_lines = vim.fn.getreg(reg1, 0, true) --[[@as string[] ]]
  local reg2_lines = vim.fn.getreg(reg2, 0, true) --[[@as string[] ]]

  vim.cmd("tabnew")
  local reg1_bufnr = vim.api.nvim_get_current_buf()
  local reg1_name = vim.fn.tempname() .. "/Register " .. reg1
  vim.api.nvim_buf_set_name(0, reg1_name)
  vim.bo.buftype = "nofile"
  vim.api.nvim_buf_set_lines(reg1_bufnr, 0, -1, false, reg1_lines)

  vim.cmd("enew")
  local reg2_bufnr = vim.api.nvim_get_current_buf()
  local reg2_name = vim.fn.tempname() .. "/Register " .. reg2
  vim.api.nvim_buf_set_name(0, reg2_name)
  vim.bo.buftype = "nofile"
  vim.api.nvim_buf_set_lines(reg2_bufnr, 0, -1, false, reg2_lines)

  vim.cmd("vertical diffsplit " .. vim.fn.fnameescape(reg1_name))
  vim.cmd("wincmd p")
end, { bar = true, nargs = "*" })

-- DAP keybindings
vim.keymap.set('n', '<leader>da', "<cmd>lua DAPATTACH.attach_python_debugger()<CR>", opts)
vim.keymap.set('n', '<leader>dc', "<cmd>lua require'dap'.continue()<CR>", opts)
vim.keymap.set('n', '<leader>dov', "<cmd>lua require'dap'.step_over()<CR>", opts)
vim.keymap.set('n', '<leader>dsi', "<cmd>lua require'dap'.step_into()<CR>", opts)
vim.keymap.set('n', '<leader>dso', "<cmd>lua require'dap'.step_out()<CR>", opts)
vim.keymap.set('n', '<leader>db', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
vim.keymap.set('n', '<leader>dsb', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
vim.keymap.set('n', '<leader>dlp', "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)
vim.keymap.set('n', '<leader>dr', "<cmd>lua require'dap'.repl_open()<CR>", opts)
vim.keymap.set('n', '<leader>dl', "<cmd>lua require'dap'.run_last()<CR>", opts)
vim.keymap.set('n', '<leader>ds', "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>", opts)
vim.keymap.set('n', '<leader>di', "<cmd>lua require'dap.ui.widgets'.hover()<CR>", opts)
vim.g.dap_virtual_text = "v:true"

-- General keybindings
vim.keymap.set('n', '<leader>cd', "<cmd>lua require'custom_pickers'.common_paths()<CR>", opts)
vim.keymap.set('n', '<leader>gg', "<cmd>Neogit<CR>", opts)
vim.keymap.set('n', '<leader>gl', "<cmd>Neogit log<CR>", opts)
vim.keymap.set('n', '<leader>gp', "<cmd>Neogit push<CR>", opts)
vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles<CR>", opts)
vim.keymap.set('n', '<leader>gD', "<cmd>DiffviewOpen<CR>", opts)
vim.keymap.set('n', '<leader>cc', "<Cmd>aboveleft vertical RegDiff + a<CR>", {silent = true})

-- Vim fugitive
vim.keymap.set("n", "<leader>gs", ":Git<CR>", opts)
vim.keymap.set("n", "<leader>gh", ":diffget //2<CR>", opts)
vim.keymap.set("n", "<leader>gh", ":diffget //3<CR>", opts)
vim.keymap.set("n", "<leader>gh", ":Gdiffsplit!<CR>", opts)

EOF

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  use 'navarasu/onedark.nvim' -- Theme inspired by Atom
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Much prefer to use fzy native due to fzf being too fuzzy
  use("nvim-telescope/telescope-fzy-native.nvim")

  -- CUSTOM ADDITIONS

  -- use({
  --   "folke/which-key.nvim",
  --     config = function()
  --       require("which-key").setup({})
  --     end
  -- })
  -- LSP
  use("ray-x/lsp_signature.nvim")
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("null-ls").setup()
    end,
    requires = { "nvim-lua/plenary.nvim" },
  })
  -- Telescope
  use("nvim-lua/popup.nvim")
  use("nvim-lua/plenary.nvim")
  use("nvim-telescope/telescope-live-grep-args.nvim")
  use("nvim-telescope/telescope-file-browser.nvim")
  use("nvim-telescope/telescope-dap.nvim")
  -- Treesitter
  use("nvim-treesitter/playground")
  use("nvim-treesitter/nvim-treesitter-context")
  -- Git
  use("emmanueltouzery/agitator.nvim")
  use("TimUntersberger/neogit")
  use("sindrets/diffview.nvim")
  -- DAP
  use("theHamsta/nvim-dap-virtual-text")
  use("mfussenegger/nvim-dap")
  use("mfussenegger/nvim-dap-python")
  -- Fonts & Styling
  use("lambdalisue/nerdfont.vim")
  use("ryanoasis/vim-devicons")
  use("kyazdani42/nvim-web-devicons")
  -- Colorschemes
  use("LunarVim/Colorschemes")
  -- Performance optimization
  use("lewis6991/impatient.nvim")
  -- Applications
  use("ThePrimeagen/vim-be-good")
  -- General
  use('mechatroner/rainbow_csv')
  use('tpope/vim-surround')
  -- Programming languages
  use('edgedb/edgedb-vim')
  -- SQL
  use('tpope/vim-dadbod')
  use('kristijanhusak/vim-dadbod-ui')
  use('kristijanhusak/vim-dadbod-completion')
  -- Testing
  use('nvim-neotest/neotest-python')
  use('nvim-neotest/neotest-plenary')
  use('nvim-neotest/neotest-vim-test')
  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim"
    }
  }


  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- Significantly reduced startup time through caching
require('impatient')

-- Global options
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Options
-- Kickstart default options:
vim.o.hlsearch = false
vim.wo.number = true
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'
vim.o.termguicolors = true
vim.cmd [[colorscheme habamax]]
vim.o.completeopt = 'menuone,noselect'

-- Personal Options
local opts = {silent=true}
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.updatetime = 300
vim.opt.shortmess:append("c")
vim.opt.lazyredraw = true
vim.opt.foldnestmax = 10
vim.opt.foldenable = false
vim.opt.foldlevel = 2
vim.opt.foldmethod = "expr"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.hidden = true
vim.opt.list = true
vim.opt.listchars = "tab:›  ,trail:⋅"
vim.opt.laststatus = 3
vim.opt.clipboard:append("unnamedplus")

-- General keymaps
-- Kickstart Default Keymaps
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Personal General Keymaps, TODO: review, might break stuff
vim.keymap.set('n', 'gv', '<c-v>', opts)
vim.keymap.set('n', '<C-L>', '<cmd>bprev<CR>', opts)
vim.keymap.set('n', '<C-H>', '<cmd>bnext<CR>', opts)
vim.keymap.set('n', '<leader><CR>', '<cmd>tabnew | term<CR>', opts)
vim.keymap.set('n', '<leader>pp', '<cmd>gg=G<C-o><C-o>', opts)
vim.keymap.set('n', '<leader>cfd', '<cmd>cd %:p:h<CR><cmd>pwd<CR>', opts)
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
vim.keymap.set('n', '<leader><BS>', '<cmd>bp|bd #<CR>', opts)

-- General Autocommands
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

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
vim.api.nvim_create_autocmd({ "FileType"}, {
  pattern = {"lua"},
  command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType"}, {
  pattern = {"toml"},
  command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType"}, {
  pattern = {"vim"},
  command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType"}, {
  pattern = {"html"},
  command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})

-- Plugin initialization

-- PERSONAL

require "lsp_signature".setup()

local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.diagnostics.ruff.with({
      extra_args = {
        '--ignore E501',
      }
    }),
  },
})

-- DEFAULT KICKSTART INITIALIZATIONS
-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'seoul256', --TODO: experiment with themes
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

-- require("ibl").setup { indent = { highlight = highlight } }
require("ibl").setup {
  scope = { enabled = false },
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
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

require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-plenary"),
    require("neotest-vim-test")({
      ignore_file_types = { "python", "vim", "lua" },
    }),
  },
})

require("telescope").load_extension "file_browser"


-- Enable telescope fzy native, if installed
pcall(require('telescope').load_extension, 'fzy')

-- Telescope keymaps
vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>", { noremap = true })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles'})
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fm', require('telescope.builtin').marks, { desc = '[F]ind [M]arks' })

vim.keymap.set('n', '<leader>fg', "<cmd>lua require'telescope'.extensions.live_grep_args.live_grep_args()<CR>", opts)
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').resume, { desc = '[F]ind [R]esume previous query' })
vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_bcommits, { desc = '' })
vim.keymap.set('n', '<leader>gd', require('telescope.builtin').git_status, { desc = '' })
vim.keymap.set('n', '<leader>fo', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'bash',
    'lua',
    'python',
    'rust',
    'typescript',
    'json',
    'yaml',
    'html',
    'javascript',
    'vue',
  },

  highlight = { enable = true },
  indent = { enable = true, disable = {'python'} },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>lr', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>lca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>ld', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>lds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>lws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('<leader>lf', vim.lsp.buf.format, 'Lsp based format')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = 'Format current buffer with LSP' })
end

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local servers = {
  'rust_analyzer',
  'bashls',
  'pylsp',
  'tsserver',
  'lua_ls',
  'texlab',
  'jsonls',
  'lemminx',
  'dockerls',
  'vuels',
  'crystalline',
  'html',
  -- 'rome', Enable this once there is HTML support, should have linting
}

-- Ensure the servers above are installed
require('mason-lspconfig').setup {
  ensure_installed = servers,
}

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Turn on lsp status information
require('fidget').setup()

-- Example custom configuration for lua
--
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    },
  },
}

require'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = true,
          ignore = {
            'W391',
            'E501',
            'E251',
            'E125',
            'E121',
            'E302',
          },
          maxLineLength = 100
        },
        autopep8 = {
          enabled = false,
        },
        flake8 = {
          enabled = false,
          ignore = {
            'E501',
          }
        },
      }
    }
  }
}

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- DAP initialization and configuration
require('dap-python').setup('~/.venvs/debugpy/bin/python')
require('dap-python').test_runner = 'pytest'

-- User commands

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

-- DAP custom functions

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
  local adapter_config = require('debugpy_config')
  local config = nil
  for candidate_parent, conf in pairs(adapter_config) do
    local patternized_cp = string.gsub(candidate_parent, '-', '.')
    local is_substr = string.match(vim.fn.getcwd(), patternized_cp)
    if is_substr ~= nil then
      config = conf
      config['local_root'] = candidate_parent
      break
    end
  end
  if config == nil then
    error("No configured local path is a substring of current neovim path")
  end
  local dap = require "dap"
  local docker_service_name_substr = config['docker_service_name_substr']
  local adapter = config['adapter']
  if docker_service_name_substr ~= nil then
    for candidate, ip in pairs(docker_service_ips) do
      local patternized_name = string.gsub(docker_service_name_substr, '-', '.')
      local is_substr = string.match(candidate, patternized_name)
      if is_substr ~= nil then
        adapter['host'] = ip
        break
      end
    end
  end
  pythonAttachAdapter = {
    type = "server";
    host = adapter;
    port = tonumber(adapter['port']);
  }
  local pythonAttachConfig = {
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
        localRoot = config['local_root']; -- Wherever your Python code lives locally.
        remoteRoot = config['remote_root']; -- Wherever your Python code lives in the container.
      };
    };
    justMyCode = false;
  }
  local session = dap.attach(adapter, pythonAttachConfig)
  if session == nil then
    io.write("Error launching adapter");
  end
  dap.repl.open()
end

-- Plugin keybindings

-- DAP keybindings
vim.keymap.set('n', '<leader>da', "<cmd>lua DAPATTACH.attach_python_debugger()<CR>", opts)
vim.keymap.set('n', '<leader>dc', "<cmd>lua require'dap'.continue()<CR>", opts)
vim.keymap.set('n', '<leader>do', "<cmd>lua require'dap'.step_over()<CR>", opts)
vim.keymap.set('n', '<leader>dsi', "<cmd>lua require'dap'.step_into()<CR>", opts)
vim.keymap.set('n', '<leader>dso', "<cmd>lua require'dap'.step_out()<CR>", opts)
vim.keymap.set('n', '<leader>db', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
vim.keymap.set('n', '<leader>dsb', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
vim.keymap.set('n', '<leader>dlp', "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)
vim.keymap.set('n', '<leader>dr', "<cmd>lua require'dap'.repl_open()<CR>", opts)
vim.keymap.set('n', '<leader>dl', "<cmd>lua require'dap'.run_last()<CR>", opts)
vim.keymap.set('n', '<leader>ds', "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>", opts)
vim.keymap.set('n', '<leader>df', "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.frames)<CR>", opts)
vim.keymap.set('n', '<leader>di', "<cmd>lua require'dap.ui.widgets'.hover()<CR>", opts)
vim.g.dap_virtual_text = "v:true"

-- Testing related keybindings
vim.keymap.set('n', '<leader>tr', "<cmd>lua require'neotest'.run.run()<CR>", opts)
vim.keymap.set('n', '<leader>td', "<cmd>lua require'neotest'.run.run({strategy = 'dap'})<CR>", opts)
vim.keymap.set('n', '<leader>ta', "<cmd>lua require'neotest'.run.run(vim.fn.expand('%'))<CR>", opts)

-- Vim fugitive
vim.keymap.set("n", "<leader>gs", ":Git<CR>", opts)
vim.keymap.set("n", "<leader>gh", ":diffget //2<CR>", opts)
vim.keymap.set("n", "<leader>gh", ":diffget //3<CR>", opts)
vim.keymap.set("n", "<leader>gh", ":Gdiffsplit!<CR>", opts)

-- General keybindings
vim.keymap.set('n', '<leader>cd', "<cmd>lua require'custom_pickers'.common_paths()<CR>", opts)
vim.keymap.set('n', '<leader>gg', "<cmd>Neogit<CR>", opts)
vim.keymap.set('n', '<leader>gl', "<cmd>Neogit log<CR>", opts)
vim.keymap.set('n', '<leader>gp', "<cmd>Neogit push<CR>", opts)
vim.keymap.set('n', '<leader>gD', "<cmd>DiffviewOpen<CR>", opts)
vim.keymap.set('n', '<leader>cc', "<Cmd>aboveleft vertical RegDiff + a<CR>", {silent = true})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

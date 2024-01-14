-- Telecscope additions
pcall(require("telescope").load_extension, "file_browser")
-- Enable telescope fzy native, if installed
pcall(require('telescope').load_extension, 'fzy')
-- Enable telescope live grep args
pcall(require('telescope').load_extension, 'live_grep_args')
-- Enable telescope-dap
pcall(require('telescope').load_extension, 'nvim-telescope/telescope-dap.nvim')

return {
  -- LSP
  {
    'https://github.com/nvimtools/none-ls.nvim',
  },
  -- Much prefer to use fzy native due to fzf being too fuzzy
  'nvim-telescope/telescope-fzy-native.nvim',

  -- Treesitter playground
  'nvim-treesitter/playground',
  'nvim-treesitter/nvim-treesitter-context',

  -- Git
  'sindrets/diffview.nvim',

  -- DAP
  'theHamsta/nvim-dap-virtual-text',
  'mfussenegger/nvim-dap',
  'mfussenegger/nvim-dap-python',

  -- Fonts & Styling
  'lambdalisue/nerdfont.vim',
  'ryanoasis/vim-devicons',
  'kyazdani42/nvim-web-devicons',

  -- Colorschemes
  'LunarVim/Colorschemes',

  -- Performance optimization
  'lewis6991/impatient.nvim',

  -- Applications
  'ThePrimeagen/vim-be-good',

  -- General
  'mechatroner/rainbow_csv',
  'tpope/vim-surround',

  -- Programming languages
  'edgedb/edgedb-vim',
  {
    'nushell/tree-sitter-nu',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },

  -- SQL
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',
  'kristijanhusak/vim-dadbod-completion',

  -- Testing
  'nvim-neotest/neotest-python',
  'nvim-neotest/neotest-plenary',
  'nvim-neotest/neotest-vim-test',
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim"
    }
  },
}

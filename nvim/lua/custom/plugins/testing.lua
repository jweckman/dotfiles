return {
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

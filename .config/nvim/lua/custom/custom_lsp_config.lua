require'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = true,
          ignore = {
            'W503',
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

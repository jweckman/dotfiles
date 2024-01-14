local opts = {silent=true}

vim.o.nu = true
vim.o.rnu = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.updatetime = 300
vim.o.shortmess:append("c")
vim.o.lazyredraw = true
vim.o.foldnestmax = 10
vim.o.foldenable = false
vim.o.foldlevel = 2
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.hidden = true
vim.o.list = true
vim.o.listchars = "tab:›  ,trail:⋅"
vim.o.laststatus = 3

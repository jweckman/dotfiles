-- File type specific autocommands
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "python" },
	command = "setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "xml" },
	command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "json" },
	command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "yaml" },
	command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "vimwiki" },
	command = "setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "vue" },
	command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "javascript" },
	command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "typescript" },
	command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "lua" },
	command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "toml" },
	command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "vim" },
	command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "html" },
	command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "esdl" },
	command = "setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "make" },
	command = "setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=0",
})

-- Perhaps temporary fix for dart commentstrings. Can probably be removed in Neovim 0.11
vim.api.nvim_create_autocmd("FileType", {
	pattern = "dart",
	callback = function()
		vim.bo.commentstring = "// %s"
	end,
})

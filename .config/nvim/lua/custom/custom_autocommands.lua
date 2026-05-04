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

local function get_zls_executable()
	local root = vim.fs.root(0, { "build.zig.zon", "build.zig" })
	if not root then
		return "zls"
	end

	-- Try to parse build.zig.zon directly (fastest)
	local zon_path = root .. "/build.zig.zon"
	local f = io.open(zon_path, "r")
	local version = nil
	if f then
		local content = f:read("*a")
		f:close()
		-- Match minimum_zig_version = "0.16.0" or mach_zig_version = "..."
		version = content:match('%.minimum_zig_version%s*=%s*"([%d%.]+)"')
			or content:match('%.mach_zig_version%s*=%s*"([%d%.]+)"')
	end

	-- NOTE: This requires manual intervention. Compile by hand and save as .local/bin/zls016
	-- Construct binary name (e.g., "0.16.0" -> "zls016")
	if version then
		local major, minor = version:match("(%d+)%.(%d+)")
		if major and minor then
			local candidate = "zls" .. major .. minor
			if vim.fn.executable(candidate) == 1 then
				return candidate
			end
		end
	end

	-- Fallback to system zls
	return "zls"
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "zig",
	callback = function()
		local zls_bin = get_zls_executable()

		vim.lsp.config("zls", {
			cmd = { zls_bin },
			settings = {
				zls = {
					semantic_tokens = "partial",
					zig_exe_path = "/usr/bin/anyzig",
					enable_build_on_save = true,
					build_on_save_step = "check",
					build_on_save_args = { "-fincremental" },
				},
			},
		})
		vim.lsp.enable("zls")
	end,
})

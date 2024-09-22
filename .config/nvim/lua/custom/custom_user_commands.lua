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

	local reg1_lines = vim.fn.getreg(reg1, 0) --[[@as string[] ]]
	local reg2_lines = vim.fn.getreg(reg2, 0) --[[@as string[] ]]

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

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
	-- Use the current buffer's path as the starting point for the git search
	local current_file = vim.api.nvim_buf_get_name(0)
	local current_dir
	local cwd = vim.fn.getcwd()
	-- If the buffer is not associated with a file, return nil
	if current_file == "" then
		current_dir = cwd
	else
		-- Extract the directory from the current file's path
		current_dir = vim.fn.fnamemodify(current_file, ":h")
	end

	-- Find the Git root directory from the current file's path
	local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 then
		print("Not a git repository. Searching on current working directory")
		return cwd
	end
	return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
	local git_root = find_git_root()
	if git_root then
		require("telescope.builtin").live_grep({
			search_dirs = { git_root },
		})
	end
end

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

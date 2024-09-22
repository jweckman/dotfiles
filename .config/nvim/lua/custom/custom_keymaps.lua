local opts = { silent = true }

-- General keybindings
vim.keymap.set("n", "gv", "<c-v>", opts)
vim.keymap.set("n", "<C-L>", "<cmd>bprev<CR>", opts)
vim.keymap.set("n", "<C-H>", "<cmd>bnext<CR>", opts)
vim.keymap.set("n", "<leader><CR>", "<cmd>tabnew | term<CR>", opts)
vim.keymap.set("n", "<leader>cfd", "<cmd>cd %:p:h<CR><cmd>pwd<CR>", opts)
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

local current_file = vim.fn.expand("%:p")
vim.keymap.set("n", "<leader>cfc", "<cmd>lua vim.fn.setreg('+', '" .. current_file .. "')<CR>", opts)

vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("n", "<leader><BS>", "<cmd>bp|bd #<CR>", opts)
vim.keymap.set("n", "<leader>cd", "<cmd>lua require'custom_pickers'.common_paths()<CR>", opts)

-- DAP keybindings
vim.keymap.set("n", "<leader>da", "<cmd>lua DAPATTACH.attach_python_debugger()<CR>", opts)
vim.keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", opts)
vim.keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_over()<CR>", opts)
vim.keymap.set("n", "<leader>dsi", "<cmd>lua require'dap'.step_into()<CR>", opts)
vim.keymap.set("n", "<leader>dso", "<cmd>lua require'dap'.step_out()<CR>", opts)
vim.keymap.set("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
vim.keymap.set(
	"n",
	"<leader>dsb",
	"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	opts
)
vim.keymap.set(
	"n",
	"<leader>dlp",
	"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
	opts
)
vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl_open()<CR>", opts)
vim.keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>", opts)
vim.keymap.set(
	"n",
	"<leader>ds",
	"<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>",
	opts
)
vim.keymap.set(
	"n",
	"<leader>df",
	"<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.frames)<CR>",
	opts
)
vim.keymap.set("n", "<leader>di", "<cmd>lua require'dap.ui.widgets'.hover()<CR>", opts)
vim.g.dap_virtual_text = "v:true"

-- Testing related keybindings
vim.keymap.set("n", "<leader>tr", "<cmd>lua require'neotest'.run.run()<CR>", opts)
vim.keymap.set("n", "<leader>td", "<cmd>lua require'neotest'.run.run({strategy = 'dap'})<CR>", opts)
vim.keymap.set("n", "<leader>ta", "<cmd>lua require'neotest'.run.run(vim.fn.expand('%'))<CR>", opts)

-- Vim fugitive
vim.keymap.set("n", "<leader>gs", ":Git <CR>", opts)
vim.keymap.set("n", "<leader>gh", ":diffget //2<CR>", opts)
vim.keymap.set("n", "<leader>gh", ":diffget //3<CR>", opts)
vim.keymap.set("n", "<leader>gh", ":Gdiffsplit!<CR>", opts)

-- Other Git related
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", opts)
vim.keymap.set("n", "<leader>gl", "<cmd>Neogit log<CR>", opts)
vim.keymap.set("n", "<leader>gp", "<cmd>Neogit push<CR>", opts)
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen<CR>", opts)
vim.keymap.set("n", "<leader>cc", "<Cmd>aboveleft vertical RegDiff + a<CR>", { silent = true })

-- Telescope keymaps can be found in init.lua since it makes it easier to see changes from upstream kickstart.nvim

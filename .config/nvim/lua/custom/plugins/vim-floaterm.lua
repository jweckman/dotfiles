return {
	"voldikss/vim-floaterm",
	config = function()
		vim.g.floaterm_shell = "nu"

		vim.g.floaterm_height = 0.9
		vim.g.floaterm_width = 0.9

		vim.keymap.set("n", "<leader>t", ":FloatermToggle<CR>", { desc = "Toggle Floaterm" })
	end,
}

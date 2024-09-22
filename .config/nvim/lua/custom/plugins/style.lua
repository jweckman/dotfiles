return {
	-- Fonts & Styling
	"lambdalisue/nerdfont.vim",
	"ryanoasis/vim-devicons",
	"kyazdani42/nvim-web-devicons",

	-- Colorschemes
	-- USERCONFIG: Colorschemes
	-- 	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	{
		"sho-87/kanagawa-paper.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	-- Colorscheme is selected at the end of init.lua for easy changes
}

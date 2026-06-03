return {
	"olimorris/codecompanion.nvim",
	version = "^19.0.0",
	opts = {},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	-- Which commands that trigger lazy loading the plugin
	cmd = {
		"CodeCompanion",
		"CodeCompanionChat",
		"CodeCompanionChatNew",
		"CodeCompanionChatClose",
		"CodeCompanionChatToggle",
		"CodeCompanionInline",
	},
	keys = {
		{
			"<leader>aa",
			function()
				require("codecompanion").toggle_chat()
			end,
			desc = "CodeCompanion: Toggle chat",
			mode = { "n", "v" },
		},
		{ "<leader>ax", "<cmd>CodeCompanionChat close<cr>", desc = "CodeCompanion: Close chat" },
	},
	config = function()
		require("codecompanion").setup({
			interactions = {
				chat = {
					adapter = "anthropic",
				},
				inline = {
					adapter = "anthropic",
				},
				cmd = {
					adapter = "anthropic",
				},
			},
			adapters = {
				http = {
					anthropic = function()
						return require("codecompanion.adapters").extend("anthropic", {
							url = "https://api.minimax.io/anthropic/v1/messages",
							schema = {
								model = {
									default = "MiniMax-M3",
									choices = { "MiniMax-M3" },
								},
							},
						})
					end,
				},
			},
		})
	end,
}

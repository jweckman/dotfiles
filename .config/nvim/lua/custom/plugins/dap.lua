return {
	-- DAP
	"theHamsta/nvim-dap-virtual-text",
	"mfussenegger/nvim-dap",
	"mfussenegger/nvim-dap-python",
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },

	-- Go / Delve
	{
		"leoluz/nvim-dap-go",
		ft = "go", -- lazy-loads on go buffers
		dependencies = { "mfussenegger/nvim-dap" },
		config = function(_, opts)
			require("dap-go").setup(opts)
		end,
	},
}

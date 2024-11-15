-- Might require this manually in the main python3_host_prog: "pip install pylsp-mypy"

local venv_path = os.getenv("VIRTUAL_ENV")
local py_path = nil
-- decide which python executable to use for mypy
if venv_path ~= nil then
	py_path = venv_path .. "/bin/python3"
else
	py_path = vim.g.python3_host_prog
end

require("lspconfig").pylsp.setup({
	settings = {
		pylsp = {
			configurationSources = { "flake8", "mypy" }, -- or other linters like 'black'
			plugins = {
				pycodestyle = {
					enabled = true,
					ignore = {
						"W503",
						"W391",
						"E501",
						"E251",
						"E125",
						"E121",
						"E302",
						"E741",
					},
					maxLineLength = 100,
				},
				autopep8 = {
					enabled = false,
				},
				flake8 = {
					enabled = false,
					ignore = {
						"E501",
					},
				},
				pylsp_mypy = {
					enabled = true,
					-- overrides = { "--python-executable", py_path, true },
					report_progress = true,
					live_mode = false,
				},
				mypy = {
					enabled = true,
					-- overrides = { "--python-executable", py_path, true },
					report_progress = true,
					live_mode = false,
				},
			},
		},
	},
})

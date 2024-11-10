local dap, dapui = require("dap"), require("dapui")

-- Automatically opens/closes dap gui when attaching/deattaching
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

dap.configurations.dart = {
	{
		type = "dart",
		request = "launch",
		name = "Launch dart",
		dartSdkPath = "/opt/dart-sdk/bin/dart",
		flutterSdkPath = "/opt/flutter/bin/flutter",
		program = "${workspaceFolder}/bin/main.dart",
		cwd = "${workspaceFolder}",
		enableAsserts = true,
	},
}

dap.adapters.dart = {
	type = "executable",
	command = "/opt/dart-sdk/bin/dart",
	args = { "debug_adapter" },
}

dapui.setup()

-- DAP initialization and configuration
require('dap-python').setup('~/.venvs/debugpy/bin/python')
require('dap-python').test_runner = 'pytest'

-- DAP custom functions

local get_docker_service_ips = function()
  local handle = io.popen("docker ps -q | xargs -n 1 docker inspect --format '{{ .Name }} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' | sed 's#^/##';")
  local service_ip_str = handle:read("*a")
  handle:close()
  local res = {}
  for line in service_ip_str:gmatch("[^\r\n]+") do
    local service_ip = {}
    for w in line:gmatch("%S+") do
      service_ip[#service_ip + 1] = w
    end
    res[service_ip[1]] = service_ip[2]
  end
  return res
end

DAPATTACH = {}

DAPATTACH.attach_python_debugger = function()
  local docker_service_ips = get_docker_service_ips()
  local adapter_config = require('debugpy_config')
  local config = nil
  for candidate_parent, conf in pairs(adapter_config) do
    local patternized_cp = string.gsub(candidate_parent, '-', '.')
    local is_substr = string.match(vim.fn.getcwd(), patternized_cp)
    if is_substr ~= nil then
      config = conf
      config['local_root'] = candidate_parent
      break
    end
  end
  if config == nil then
    error("No configured local path is a substring of current neovim path")
  end
  local dap = require "dap"
  local docker_service_name_substr = config['docker_service_name_substr']
  local adapter = config['adapter']
  if docker_service_name_substr ~= nil then
    for candidate, ip in pairs(docker_service_ips) do
      local patternized_name = string.gsub(docker_service_name_substr, '-', '.')
      local is_substr = string.match(candidate, patternized_name)
      if is_substr ~= nil then
        adapter['host'] = ip
        break
      end
    end
  end
  pythonAttachAdapter = {
    type = "server";
    host = adapter;
    port = tonumber(adapter['port']);
  }
  local pythonAttachConfig = {
    type = "python";
    request = "attach";
    connect = {
      port = tonumber(adapter['port']);
      host = host;
    };
    mode = "remote";
    name = "Remote Attached Debugger";
    cwd = vim.fn.getcwd();
    pathMappings = {
      {
        localRoot = config['local_root']; -- Wherever your Python code lives locally.
        remoteRoot = config['remote_root']; -- Wherever your Python code lives in the container.
      };
    };
    justMyCode = false;
  }
  local session = dap.attach(adapter, pythonAttachConfig)
  if session == nil then
    io.write("Error launching adapter");
  end
  dap.repl.open()
end

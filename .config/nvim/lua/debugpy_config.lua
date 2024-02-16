local adapter_config = {
  ['/home/joakim/code/docker-debug-python'] = {
    docker_service_name_substr = 'debug-python',
    adapter = {
      host = nil,
      port = '12345'
    },
    remote_root = '/home/joakim/data-pydebugdemo'
  },
  ['/home/joakim/code/demo16/odoo/src'] = {
    docker_service_name_substr = 'odoo16',
    adapter = {
      host = nil,
      port = '12345'
    },
    remote_root = '/odoo/src'
  }
}

return adapter_config

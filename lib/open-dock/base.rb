module Ops
  HOSTS_DIR = "hosts"
  CONTAINERS_DIR = "containers"
  PROVIDERS_DIR = "providers"
  NODES_DIR = "nodes"
  DEFAULT_USER = "root"

  def self.get_user_for(host_name)
    host_file = "#{HOSTS_DIR}/#{host_name}.yml"
    if File.exist? host_file
      params = YAML.load_file host_file
      if params and params.has_key? "user"
        return params["user"]
      end
    end
    return DEFAULT_USER
  end
end
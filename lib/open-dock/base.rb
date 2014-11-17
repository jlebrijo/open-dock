module Ops
  HOSTS_DIR = "hosts"
  CONTAINERS_DIR = "containers"
  PROVIDERS_DIR = "providers"


  def self.get_user_for(host_name)
    host_file = "#{HOSTS_DIR}/#{host_name}.yml"
    begin
      params = YAML.load_file host_file
      params["user"]
    rescue
      raise "Please, create '#{host_file}' configuring your host"
    end
  end
end
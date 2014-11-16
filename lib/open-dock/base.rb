module Ops
  DIR = "ops"
  HOSTS_DIR = "#{DIR}/hosts"
  CONTAINERS_DIR = "#{DIR}/containers"
  PROVIDERS_DIR = "#{DIR}/providers"


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
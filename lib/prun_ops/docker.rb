require 'droplet_kit'
require 'yaml'

module Docker
  ARGUMENTS = ["image", "ports", "command"]
  CONFIG_DIR = "#{DigitalOcean::OPS_DIR}/containers"

  def self.containers_for(host_name)
    config_file = "#{CONFIG_DIR}/#{host_name}.yml"
    begin
      config = YAML.load_file config_file
    rescue
      raise "Please, create '#{config_file}' file with all containers configured"
    end
  end

end
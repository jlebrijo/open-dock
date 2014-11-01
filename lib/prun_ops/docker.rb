require 'droplet_kit'
require 'yaml'

module Docker
  ARGUMENTS = ["image", "ports", "command", "post-conditions"]

  def self.containers_for(host_name)
    config_file = "#{Ops::CONTAINERS_DIR}/#{host_name}.yml"
    begin
      config = YAML.load_file config_file
    rescue
      raise "Please, create '#{config_file}' file with all containers configured"
    end
  end

end
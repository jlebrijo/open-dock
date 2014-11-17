require 'droplet_kit'
require 'yaml'

module DigitalOcean
  CONFIG_FILE = "#{Ops::PROVIDERS_DIR}/digitalocean.yml"

  def self.client
    begin
      config = YAML.load_file CONFIG_FILE
    rescue
      raise "Please, create '#{CONFIG_FILE}' file with token value"
    end
    DropletKit::Client.new(access_token: config["token"])
  end

  def self.build_droplet(host_name)
    begin
      params = YAML.load_file "#{Ops::HOSTS_DIR}/#{host_name}.yml"
      params["name"]= host_name
    rescue
      raise "Please, create '#{CONFIG_FILE}' file with token value"
    end
    DropletKit::Droplet.new params
  end
end

module DropletKit
  class Client
    def find_droplet_by_name(host_name)
      self.droplets.all.find{|d| d.name == host_name}
    end
  end
end
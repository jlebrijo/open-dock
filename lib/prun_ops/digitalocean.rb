require 'droplet_kit'
require 'yaml'

module DigitalOcean
  OPS_DIR = "ops"
  CONFIG_FILE = "#{OPS_DIR}/providers/digitalocean.yml"

  def self.client
    begin
      config = YAML.load_file CONFIG_FILE
    rescue
      raise "Please, create '#{CONFIG_FILE}' file with token value"
    end
    DropletKit::Client.new(access_token: config["token"])
  end

  def self.build_droplet(name)
    begin
      params = YAML.load_file "#{OPS_DIR}/hosts/#{name}.yml"
      params["name"]= name
    rescue
      raise "Please, create '#{CONFIG_FILE}' file with token value"
    end
    DropletKit::Droplet.new params
  end
end

module DropletKit
  class Client
    def find_droplet_by_name(name)
      self.droplets.all.find{|d| d.name == name}
    end
  end
end
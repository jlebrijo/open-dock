require 'droplet_kit'

class DigitalOcean < Provider

  def initialize
    config_file = "#{Ops::PROVIDERS_DIR}/#{self.class.name.underscore}.yml"
    begin
      config = YAML.load_file config_file
    rescue
      raise "Please, create '#{config_file}' file with token value"
    end
    @connection = DropletKit::Client.new(access_token: config["token"])
  end

  def create(config)
    droplet = DropletKit::Droplet.new config
    resp = @connection.droplets.create droplet
    if resp == droplet
      ip = @connection.find_droplet_by_name(config["name"]).networks["v4"].first.ip_address
      say "Droplet #{config["name"]} (IP: #{ip}) successfully created!"
    else
      raise resp
    end
  end

  def delete(host)
    begin
      id = @connection.find_droplet_by_name(host).id
      resp = @connection.droplets.delete id: id
    rescue NoMethodError
      raise "#{host} does not exist"
    rescue
      raise resp
    end

    if resp.is_a?(TrueClass)
      say "Droplet #{host} successfully deleted!"
    else
      raise resp
    end
  end

  def list_params
    say "\nSizes:"
    @connection.sizes.all.each do |i|
      say "   - #{i.slug.ljust(6)} =>   $#{i.price_monthly}/mo"
    end

    say "\nRegions:"
    @connection.regions.all.each do |i|
      say "   - #{i.slug.ljust(6)} =>   #{i.name}"
    end

    say "\nImages:"
    @connection.images.all.each do |i|
      say "   - #{i.slug.ljust(20)} =>   #{i.distribution} #{i.name}" unless i.slug.nil?
    end

    say "\nSSH Keys:"
    @connection.ssh_keys.all.each do |i|
      say "   - #{i.fingerprint} =>   #{i.name}"
    end
  end
end

module DropletKit
  class Client
    def find_droplet_by_name(host_name)
      self.droplets.all.find{|d| d.name == host_name}
    end
  end
end
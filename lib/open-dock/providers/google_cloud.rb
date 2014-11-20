require "fog"
require "google/api_client"
Fog::VERSION=1
I18n.enforce_available_locales = false

class GoogleCloud < Provider

  def initialize
    config_file = "#{Ops::PROVIDERS_DIR}/#{self.class.name.underscore}.yml"
    begin
      config = YAML.load_file config_file
    rescue
      raise "Please, create '#{config_file}' file with token value"
    end
    @connection = Fog::Compute.new provider: "Google",
                                   google_client_email: config["google_client_email"],
                                   google_project: config["google_project"],
                                   google_key_location: config["google_key_location"]
  end

  def create(config)
    say "Creating Disk and Server instance, please wait ..."
    disk = @connection.disks.create name: config["name"].parameterize,
                                    size_gb: config["disk_size_gb"],
                                    zone_name: config["zone_name"],
                                    source_image: config["source_image"]

    server = @connection.servers.bootstrap name: config["name"].parameterize,
                                           machine_type: config["machine_type"],
                                           zone_name: config["zone_name"],
                                           disks: [disk.get_as_boot_disk(true)],
                                           user: config["user"],
                                           public_key_path: File.expand_path(config["public_key_path"])
    server.set_disk_auto_delete true, server.disks[0]["deviceName"]

    ip = server.network_interfaces[0]["accessConfigs"][0]["natIP"]
    say "Instance #{config["name"]} (IP: #{ip}) successfully created!"
  end

  def delete(host)
    server = @connection.servers.get(host.parameterize)
    if server
      server.destroy
      say "Instance #{host} successfully deleted!"
    else
      raise "Instance #{host} does not exist in your Google account"
    end
  end

  def list_params
    say "\nMachine types:"
    @connection.flavors.all.each do |i|
      say "   - #{i.name.ljust(16)} =>   $#{i.description}"
    end

    say "\nZones"
    @connection.zones.each do |i|
      say "   - #{i.name}"
    end

    say "\nImages:"
    @connection.images.select{|z| z.deprecated.nil?}.each do |i|
      say "   - #{i.name.ljust(40)} =>   #{i.description}\n"
    end

  end
end
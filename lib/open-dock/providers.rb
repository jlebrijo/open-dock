require 'yaml'
require 'active_support/inflector'

class Provider
  def initialize(provider_name)

  end
  def create(config)
    raise "CREATE action not implemented"
  end
  def delete(host)
    raise "DELETE action not implemented"
  end
  def list_params
    raise "LIST PARAMS action not implemented"
  end
end

Dir.glob("#{File.dirname(__FILE__)}/providers/*.rb").each { |r| load r }

class ProviderFactory
  class << self
    def build(provider_name)
      provider_name.classify.constantize.new
    end

    def list_providers
      say Dir.glob("#{File.dirname(__FILE__)}/providers/*.rb").
          select{|f| f.include? ".rb"}.
          map{|f| f.split("/").last.split(".")[0]}.
          join ", "
    end
  end
end

class Host
  def initialize(host_name)
    @host = host_name
    config_file = "#{Ops::HOSTS_DIR}/#{host_name}.yml"
    begin
      @config = YAML.load_file "#{config_file}"
      @config["name"]= host_name
    rescue
      raise "Please, create '#{config_file}' file with token value"
    end
    @provider = ProviderFactory.build @config["provider"]
  end
  def create
    @provider.create @config
  end
  def delete
    @provider.delete @host
  end
end
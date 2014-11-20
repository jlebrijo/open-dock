require 'rubygems'
require 'commander/import'
require 'net/ssh'
require 'open-dock/base'
require 'open-dock/providers'
require 'open-dock/docker'
require 'open-dock/version'

program :name, 'ops'
program :version, OpenDock::VERSION
program :description, 'Encapsulates Operations commands for complex server clouds: Provision and Configuration from all possible providers such as DigitalOcean, Google Cloud, Rackspace, Linode,...'
program :help_formatter, :compact

Dir.glob("#{File.dirname(__FILE__)}/commands/*.rb").each { |r| load r }
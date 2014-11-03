require 'rubygems'
require 'commander/import'
require 'net/ssh'
require 'prun-ops/base'
require 'prun-ops/digitalocean'
require 'prun-ops/docker'
require 'prun-ops/version'

program :name, 'ops'
program :version, PrunOps::VERSION
program :description, 'Helps to manage Provision/Configuration/Deployment processes based on DigitalOcean, Docker, Chef and Capistrano'
program :help_formatter, :compact

require 'prun-ops/commands/list'
require 'prun-ops/commands/create_host'
require 'prun-ops/commands/delete_host'
require 'prun-ops/commands/create_domain'
require 'prun-ops/commands/delete_domain'
require 'prun-ops/commands/ship_host'
require 'prun-ops/commands/unship_host'
require 'prun-ops/commands/exec_host'
require 'prun-ops/commands/provision_host'


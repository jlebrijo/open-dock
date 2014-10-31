require 'rubygems'
require 'commander/import'
require 'net/ssh'
require 'prun_ops/base'
require 'prun_ops/digitalocean'
require 'prun_ops/docker'
require 'prun_ops/version'

program :name, 'ops'
program :version, PrunOps::VERSION
program :description, 'Helps to manage Provision/Configuration/Deployment processes based on DigitalOcean, Docker, Chef and Capistrano'
program :help_formatter, :compact

require 'prun_ops/commands/list'
require 'prun_ops/commands/create_host'
require 'prun_ops/commands/delete_host'
require 'prun_ops/commands/create_domain'
require 'prun_ops/commands/delete_domain'
require 'prun_ops/commands/ship_host'
require 'prun_ops/commands/unship_host'
require 'prun_ops/commands/exec_host'


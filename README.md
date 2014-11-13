# PrunOps

Covers all Operations in a Ruby on Rails Application server:

1. PROVISION: Create hosts and ship them with Docker containers.
1. CONFIGURATION: Build Chef cookbooks and configure/re-configure your servers. Based on [PRUN-CFG cookbook](https://supermarket.getchef.com/cookbooks/prun-cfg).
1. DEPLOYMENT: Capistrano tasks to depoly your rails Apps.
1. DIAGNOSIS: Capistrano diagnosis tools to guet your Apps status on real time.
1. RELEASE: Rake tasks to manage and tag version number in your Apps (X.Y.Z).
1. BACKUP: Backup policy for database and files in your Apps, using git as storage.

Based on [PRUN docker image](https://registry.hub.docker.com/u/jlebrijo/prun/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prun-ops'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prun-ops

## Usage: Provision with OPS command

OPS command is focused to cover first Provision configurations for a the Operations of your infrastructure.

You can create an infrastructure project (like me [/ops](https://github.com/jlebrijo/ops)) 

```
mkdir ops && cd ops
rbenv local 2.1.2
git init
```

Create a Gemfile:

```
source 'https://rubygems.org'

gem 'prun-ops'

# OPTIONAL: Add next gems if you want to integrate with Chef as Configuration management tecnology
gem 'knife-solo'
gem 'librarian-chef'
gem 'foodcritic'
```

And: `bundle install`

To avoid `bundle exec` repfix: `bundle install --binstubs .bundle/bin`

Or integrate it within your Chef infrastructure project. Just add the gem to your Gemfile.

### Folder Structure

TODO: `ops init` to create this structure

Structure:

```
ops
  providers
    digitalocean.yml
  hosts
    example.com.yml
  containers
    example.com.yml
```

#### Provider file syntax

TODO: Create more providers (aws, linode, gcloud, ...)

For a Digital Ocean provider create a file (ops/providers/digitalocean.yml) with your account API key:

```yml
token: a206ae60dda6bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxcf0cbf41
```

#### Host file syntax

For a Digital Ocean host we can make the following file (ops/hosts/example.com.yml):

```yml
user: core   # User to connect the host
# Values to configure DigitalOcean machine
size:     1gb
region:   ams3
image:    coreos-stable
ssh_keys:
  - e7:51:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:88:57
```

And create the host: `ops create host example.com`

### Containers file syntax

In this file we can configure all containers to run in the host provided in the name:

```yml
www:
  image: jlebrijo/prun
  ports:
    - '2222:22'
    - '80:80'
#  command: /bin/bash

# OPTIONS: use the long name of the options, 'detach' instead of '-d'
  detach: true
#  interactive: true
#  memory: 8g
#  cpuset: 0-7

# POST-CONDITIONS: execute after build the container:
  post-conditions:
    - sshpass -p 'J3mw?$_6' ssh-copy-id -o 'StrictHostKeyChecking no' -i ~/.ssh/id_rsa.pub root@lebrijo.com -p 2222
    - ssh root@lebrijo.com -p 2222 "echo 'root:K8rt$_?1' | chpasswd"

# here you can create other containers
# db:
#   image: ubuntu/postgresql
```

Create containers at host: `ops ship host example.com`

### Commands

Create/delete domain names, create/delete hosts and ship/unship hosts:

* `ops create host HOST_NAME` create the host defined by the name of the file in the 'ops/hosts' folder.
* `ops delete host HOST_NAME`
* `ops create domain DOMAIN_NAME [IP_ADDRESS]` create a domain to be managed by DigitalOcean.
* `ops delete domain DOMAIN_NAME [IP_ADDRESS]`
* `ops ship host HOST_NAME` run the containers in the host.
* `ops unship host HOST_NAME`

### TODO: Configuration with Chef

Configuration with chef commands

* `ops configure host HOST_NAME`: configure with chef all containers in host. Here you need to install knife-solo gem.
    * knife solo cook [container_user]@[container_dns_name] -p [container_ssh_port]

## Usage: Day-to-day rake and capistrano tasks

Add the gem to the Gemfile in your Rails Application.

`gem "capistrano-rails"` is included as prun-ops requirement. Create basic files `cap install`

Capfile should include these requirements:

```ruby
require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
```

Add to your config/deploy.rb this:

```ruby
## PRUN-OPS configuration
require 'prun-ops/cap/all'
```

Your config/deploy/production.rb:

```
server "example.com", user: 'root', roles: %w{web app}, port: 2222
```

Note: Remember change this line in production.rb file: `config.assets.compile = true`

### Deployment

* `cap [stg] deploy` deploy your app as usual
* `cap [stg] deploy:restart` restart thin server of this application
* `cap [stg] deploy:stop` stop thin server
* `cap [stg] deploy:start` start thin server
* `cap [stg] db:setup` load schema and seeds for first DB setup

### Backup

Backups/restore database and files in your Rails app.

Configure your 'config/deploy.rb':

```ruby
# Backup directories
set :backup_dirs, %w{public/uploads}
```

And your 'config/applciation.rb':

```ruby
    # Backup directories
    config.backup_dirs = %w{public/ckeditor_assets public/system}

    # Backup repo
    config.backup_repo = "git@github.com:example/backup.git"
```

![backup schema](https://docs.google.com/drawings/d/1Sp8ysn46ldIWRxaLUHfzpu7vK0zMjh4_iMpEP1U6SuU/pub?w=642&h=277  "Backup commands schema")

* `cap [stg] pull:data`: downloads DDBB and file folders from the stage you need.
* `cap [stg] backup:restore[TAG]`: Restore the last backup into the stage indicated, or tagged state if TAG is provided.
* `rake backup |TAG|`: Uploads backup to git store from local, tagging with date, or with TAG if provided. Useful to backup production stage.
* `rake backup:restore |TAG|`: Restore last backup copy, or tagged with TAG if provided.

### TODO: Release

Release management

* `rake release[VERSION]` push forward from dev-branch to master-branch and tag the commit with VERSION name.
* `rake release:delete[VERSION]` remove tag with VERSION name.

![Release management](https://docs.google.com/drawings/d/1IEWCIhDFqREVVjSwM9bPfVpyNm3jIoNF4Xn8y-dZHTg/pub?w=871&h=431  "Release management")

* `rake git:ff` merge dev branch towards master branch without releasing

### Diagnosis

Some capistrano commands useful to connect to server and help with the problem solving.

* `cap [stg] ssh` open a ssh connection with server
* `cap [stg] log[LOG_FILENAME]` tail rails log by default, or other if LOG_FILENAME is provided
* `cap [stg] c` open a rails console with server
* `cap [stg] x[COMMAND]` execute any command in server provided as COMMAND (i.e.: cap production x['free -m'])


## Contributing

1. Fork it ( https://github.com/[my-github-username]/prun-ops/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

[MIT License](http://opensource.org/licenses/MIT). Made by [Lebrijo.com](http://lebrijo.com)

## Release notes

### v0.0.2

* First publication

### v0.0.4

* Changing homepage and License
* start|stop|restart thin server per application as Capistrano task

### v0.0.5

* Removing Application server version (thin 1.6.2) dependency

### v0.0.6

* Fixing DigitalOcean images error when slug is nil for client images
* Adding git:ff rake task

### v0.0.8

* Adding backup[tag] capistrano task for production
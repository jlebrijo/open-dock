# Open Dock

Covers Provision and Configuration Operations for complex server clouds:

1. PROVISION: Create hosts from all possible cloud providers (i.e.: DigitalOcean, GCloud, Rackspace, Linode ...).
1. WIRING: Ship those hosts with Docker containers.
1. CONFIGURATION: Build Chef cookbooks and configure/re-configure your servers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'open-dock'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install open-dock


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

gem 'open-dock'

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

### TODO: Configuration with Chef

Configuration with chef commands

* `ops configure CONTAINER_NAME HOST_NAME`: configure with chef a container in host. Here you need to install knife-solo gem.
    * knife solo cook [container_user]@[HOST_NAME] -p [container_ssh_port]

### Commands

Create/delete domain names, create/delete hosts and ship/unship hosts:

* `ops create HOST_NAME` create the host defined by the name of the file in the 'ops/hosts' folder.
* `ops delete HOST_NAME`
* TODO: `ops recreate HOST_NAME` delete/create the host.
* `ops ship HOST_NAME` run the containers in the host.
* `ops unship HOST_NAME`
* TODO: `ops reship HOST_NAME` unship/ship all containers from host.
* TODO: `ops configure CONTAINER_NAME HOST_NAME` configure container with chef.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/open-dock/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

[MIT License](http://opensource.org/licenses/MIT). Made by [Lebrijo.com](http://lebrijo.com)

## Release notes

### v0.0.10

* First publication: split 'open-dock' gem from 'prun-ops' gem 

### v0.0.11

* Remove create/delete domain commands
* Remove "host" word from all commands
* Remove /ops folder from providers, hosts and containers subfolders
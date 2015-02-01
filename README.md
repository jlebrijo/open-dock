# Open Dock

Gem for orchestrating the creation of infrastructures of hosts and containers. You can manage CREATION (in any provider: DigitalOcean, Gcloud, vagrant for the moment), SHIPPING (with docker containers) and CONFIGURING (with Chef). All with 3 commands per host:

1. `ops create prod.exaple.com`: Create hosts from all possible cloud providers (i.e.: DigitalOcean, GCloud, Rackspace, Linode ...).
1. `ops ship prod.exaple.com`: Ship those hosts with Docker containers.
1. `ops cconfigure prod.exaple.com`: Build Chef cookbooks and configure/re-configure your servers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'open-dock'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install open-dock




## Initialize project

TODO: `ops init` to create folder structure and example files

Structure:

```
providers
  digital_ocean.yml
  google_cloud.yml
hosts
  example.com.yml
containers
  example.com.yml
```

## Configure PROVIDER

`ops list` command will list all providers supported by this gem.

### Digital Ocean

Pre-requisites:

* Create DigitalOcean account
* Activate Read/Write token at: DigitalOcean console > Apps & API > Generate new token. Be sure to give write permissions.

For a Digital Ocean provider create a file (ops/providers/digital_ocean.yml) with your account API key:

```yml
token: a206ae60dda6bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxcf0cbf41
```

### Google Cloud

Pre-requisites:

* Create GoogleCloud account
* Create a Project at the console
* Create a service account in the project console:
    * [Here the instructions](https://developers.google.com/accounts/docs/OAuth2ServiceAccount#creatinganaccount)
    * Download the .p12 file (for the ‘google_key_location’ parameter) and annotate ‘google_client_email’
* Create a firewall rule to connect properly the servers (i.e. Allow tcp:1-65535): Project console > Compute > Compute Engine > Networks > default> Firewall rules > Create New

To configure Google Cloud provider create a file (ops/providers/digital_ocean.yml) with these params:

```yml
google_client_email: "850xxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxtauvbl@developer.gserviceaccount.com"
google_project: "project_name"
google_key_location: "path_to_your_p12_file"
```

## Configure HOST

With these files you can configure your instances/servers/droplets/ships on every provider you have configured in the last point.

Helpful commands:

* `ops list digital_ocean` list all possible parameter values to use in the yml file
* `ops create example.com` will create your host

By default `user` to connect to host will be 'root' if not configured.

### Vagrant Host

With Vagrant we do not need provider file anymore. But obviously qyou need to have installed in your workstation:

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)

For a Vagrant host we can make the following file (ops/hosts/example.com.yml):

```yml
provider: vagrant
user: root   # User to connect the host
memory:     2048
ip:         192.168.33.20
box:        ubuntu/trusty64  ## Search on https://atlas.hashicorp.com
```

`ops create example.com` will create Vagrantfile, so you can suspend it `vagrant suspend` or manipulate with vagrant commands.

### Digital Ocean Host

For a Digital Ocean host we can make the following file (ops/hosts/example.com.yml):

```yml
provider: digital_ocean
user: core   # User to connect the host
# Values to configure DigitalOcean machine
size:     1gb
region:   ams3
image:    coreos-stable
ssh_keys:
  - e7:51:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:88:57
```

### Google Cloud Host

For a Google Cloud host we can make the following file (ops/hosts/example.com.yml):

```yml
provider: google_cloud
user: core   # User to connect the host
# Values to configure GoogleCloud machine
machine_type: g1-small
zone_name: europe-west1-b
public_key_path: ~/.ssh/id_rsa.pub
source_image: coreos-stable-444-5-0-v20141016
disk_size_gb: 10
```

##Configure hosted CONTAINERS (Docker)

To use this command you need [Docker](https://docs.docker.com/installation/) installed in the server.

In this file we can configure all containers to run in the host provided in the name:

```yml
www:
  hostname: example.com
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
#  post-conditions:
#    - sshpass -p 'J3mw?$_6' ssh-copy-id -o 'StrictHostKeyChecking no' -i ~/.ssh/id_rsa.pub root@lebrijo.com -p 2222
#    - ssh root@lebrijo.com -p 2222 "echo 'root:Kxxxxx1' | chpasswd"

# here you can create other containers
# db:
#   hostname: db.lebrijo.com
#   image: ubuntu/postgresql
```

`ops ship example.com` will create all containers configured on 'containers/example.com.yml' file

Note: host SSH credentials (id_rsa.pub and authorized_keys) are copied by default to container, in order to have the same access to container.

### Shipping your local Docker

You can create a file `containers/localhost.example.com.yml` where you can define containers. And launch them on your workstation:

```
ops ship localhost.example.com
```

By convention:

* If [host_name] includes "localhost" string, it is assumed that containers are shipped as docker containers in local workstation

## Configure Containers (are nodes for Chef)

To use this command you need:

* Chef installed in your nodes
* SSHd running in your nodes

Configuration with chef commands

* `ops configure HOST_NAME`: configure with chef all containers in host. Here you need to install knife-solo gem.
    * Equivalent to: knife solo cook root@[HOST_NAME] -p [each container_ssh_port]
    * `--container CONTAINER_NAME` to configure one container (default: '--container all')

By convention:

* "root" is the user by default in all containers
* Each container configuration is defined in a Chef node: `nodes/[host_name]/[container_name].json`

```
# Configure all containers in 'example.com' host
ops configure example.com
# Configure 'www' container in 'example.com' host
ops configure example.com --container www
# == knife solo cook root@example.com nodes/example.com/www.json -p 2222
```

## SSH connections

SSH connection to host or container:

```
ops ssh HOST_NAME [CONTAINER_NAME]
```

Assuming SSHd installed in containers and hosts, you can

* Access to host: `ops ssh example.com` equivalent to `ssh root@example.com`
* Access to 'www' container: `ops ssh example.com www` equivalent to `ssh root@example.com -p 2222`

## Commands

Create/delete domain names, create/delete hosts and ship/unship hosts:

* TODO: `ops init` initialize needed folders and example files
* TODO: `ops list` shows all providers for this gem. Create more providers (aws, linode, gcloud, ...)
* `ops create HOST_NAME` create the host defined by the name of the file in the 'ops/hosts' folder.
* `ops delete HOST_NAME`
* TODO: `ops recreate HOST_NAME` delete/create the host.
* `ops exec HOST_NAME "COMMAND"` execute any command on a host remotely (i.e. ops exec example.com 'docker ps -a')
* `ops ship HOST_NAME` run the containers in the host.
* `ops unship HOST_NAME`
* TODO: `ops reship HOST_NAME` unship/ship all containers from host.
* `ops configure HOST_NAME` configure all containers with chef.
* `ops ssh HOST_NAME [CONTAINER_NAME]` ssh connection to host or container
* TODO: `ops graph` creates a graphic with all hosts and nodes in the project

## Create your infrastructure project (/ops)

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

# OPTIONAL: Add next gems if you want to integrate with Chef as Configuration management technology
gem 'knife-solo'
gem 'librarian-chef'
gem 'foodcritic'
```

And: `bundle install`

To avoid `bundle exec` repfix: `bundle install --binstubs .bundle/bin`

Or integrate it within your Chef infrastructure project. Just add the gem to your Gemfile.

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

### v0.0.13

* Added Google Cloud as provider
* Now providers files are called underscored: digital_ocean, google_cloud ....
* In hosts YAML files we should include which provider will be built (i.e. provider: digital_ocean)

### v0.1.0

* Launch local containers with `containers/localhost.yml` and `ops ship localhost`

### v0.1.1

Create command `ops configure [host_name]` this will cook all containers. By convention:

* "root" is the user in all containers
* Each container configuration is defined in a Chef node: `nodes/[container_name].[host_name].json`
* Then you have to create all container name records in your DNS provider: `[container_name].[host_name]   CNAME   [host_name].`
* If [host_name] include "localhost" string, it is assumed that containers are shipped on local workstation

### v0.1.2

* Delete post-conditions from containers files. By default host credentials are passed to conainers.

### v0.1.3

* Chef containers configuration files goes to nodes/[host_name]/[container_name].json
* Create ssh connections commands: 'ops ssh [host_name] [container_name]'

### v0.1.8

* Including Vagrant provider

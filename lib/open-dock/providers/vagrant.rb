require 'erubis'

class Vagrant < Provider
  TEMPLATE = %{Vagrant.configure(2) do |config|
  config.vm.box = "<%=box%>"
  config.vm.hostname = "<%=name%>"

  config.vm.network "private_network", ip: "<%=ip%>"

  config.vm.provider "virtualbox" do |vb|
    vb.name = config.vm.hostname
    vb.memory = "<%=memory%>"
  end

  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/tmp/id_rsa.pub"
  config.vm.provision "shell", inline: <<-SHELL
    # Copy host public key
    sudo mv /tmp/id_rsa.pub /root/.ssh/authorized_keys
    sudo chown root:root /root/.ssh/authorized_keys
    # Install docker
    wget -qO- https://get.docker.io/gpg | sudo apt-key add -
    sudo sh -c "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
    sudo apt-get update
    sudo apt-get install lxc-docker -y
  SHELL
end
}
  def initialize
    # Nothing
  end
  def create(config)
    # Create Vagrantfile
    erb= Erubis::Eruby.new(TEMPLATE)
    out = erb.result(config)
    File.write "Vagrantfile", out
    # vagrant up
    system "vagrant up"
  end

  def delete(host)
    #vagrant destroy -f
    system "vagrant destroy -f"
    #Remove Vagrantfile
    system "rm Vagrantfile"
  end

  def list_params
    say "\nMemory:  RAM memory in Megabytes"
    say "\nIp: Every IP in the 192.168.0.0 range"
    say "\nBoxes: Every box from https://atlas.hashicorp.com"
  end

  private
  def create_connection(config)
    # nothing
  end
end
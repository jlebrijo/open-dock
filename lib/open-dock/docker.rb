require 'droplet_kit'
require 'yaml'

module Docker
  SPECIAL_OPTS = ["image", "ports", "command", "post-conditions"]

  def self.containers_for(host_name)
    config_file = "#{Ops::CONTAINERS_DIR}/#{host_name}.yml"
    begin
      config = YAML.load_file config_file
    rescue
      raise "Please, create '#{config_file}' file with all containers configured"
    end
  end

  def self.copy_ssh_credentials_command(container_name)
    <<-EOH
      ID=$(docker inspect -f   '{{.Id}}' #{container_name})
      # Container folder
      if sudo test -d "/var/lib/docker/aufs"; then
        CONTAINERS_DIR=/var/lib/docker/aufs/mnt
        SSH_DIR=$CONTAINERS_DIR/$ID/root/.ssh
      elif sudo test -d "/var/lib/docker/btrfs"; then
        CONTAINERS_DIR=/var/lib/docker/btrfs/subvolumes
        SSH_DIR=$CONTAINERS_DIR/$ID/root/.ssh
      elif sudo test -d "/var/lib/docker/devicemapper"; then
        CONTAINERS_DIR=/var/lib/docker/devicemapper/mnt
        SSH_DIR=$CONTAINERS_DIR/$ID/rootfs/root/.ssh
      fi

      echo SSH container folder: $SSH_DIR
      if sudo test ! -d "$SSH_DIR" ; then
        sudo mkdir $SSH_DIR
      fi

      echo Copying authorized_keys and id_rsa.pub files
      sudo touch $SSH_DIR/authorized_keys
      sudo cat ~/.ssh/authorized_keys | sudo tee -a $SSH_DIR/authorized_keys
      sudo cat ~/.ssh/id_rsa.pub | sudo tee -a $SSH_DIR/authorized_keys
      sudo chmod 600 $SSH_DIR/authorized_keys
    EOH
  end


  def self.get_container_port(container_config)
    container_config["ports"].select{|port| port.end_with? ":22"}[0].split(':')[0]
  end

end
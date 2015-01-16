require 'droplet_kit'
require 'yaml'

module Docker
  SPECIAL_OPTS = ["image", "ports", "command", "post-conditions"]
  DEFAULT_USER = "root"

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
      # Container folder
      if sudo test -d "/var/lib/docker/aufs"; then
        CONTAINERS_DIR=/var/lib/docker/aufs/mnt
      elif sudo test -d "/var/lib/docker/aufs"; then
        CONTAINERS_DIR=/var/lib/docker/btrfs/subvolumes
      fi

      ID=$(docker inspect -f   '{{.Id}}' #{container_name})
      SSH_DIR=$CONTAINERS_DIR/$ID/root/.ssh
      echo SSH container folder is $SSH_DIR
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

end
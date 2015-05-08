module Chef

  def self.install(user, host)
    Net::SSH.start(host, user) do |ssh|
      if ssh.exec!('which chef-client')
        say 'Chef already installed'
      else
        say "Installing Chef, please wait ..."
        ssh.exec! 'apt-get -y update; \
                  apt-get -y install curl build-essential libxml2-dev libxslt-dev git ; \
                  curl -L https://www.opscode.com/chef/install.sh | bash'
      end
    end
  end

  def self.cook(user, host)
    say "Configuring #{host}, please wait ....\n"
    command = "knife solo cook #{user}@#{host}"
    say "Chef CMD: #{command}\n"
    system command
  end

  def self.cook_container(user, container_name, host, ssh_port)
    say "Container '#{container_name}' configuring on #{host}, please wait ....\n"
    command = "knife solo cook #{user}@#{host} -p #{ssh_port} nodes/#{host}/#{container_name}.json"
    say "Chef CMD: #{command}\n"
    system command
  end
end
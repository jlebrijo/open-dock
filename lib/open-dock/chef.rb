module Chef
  def self.cook(user, container_name, host, ssh_port)
    say "Container '#{container_name}' configuring on #{host}, please wait ....\n"
    command = "knife solo cook #{user}@#{host} -p #{ssh_port} nodes/#{host}/#{container_name}.json"
    say "Chef CMD: #{command}\n"
    system command
  end
end
command :ssh do |c|
  c.summary = 'Connects to a host or a container with SSH'
  c.syntax = 'ops ssh [host_name] [container_name]'
  c.description = "SSH connection to host or one of its containers if write [container_name]"
  c.example "Connects to host:", 'ops ssh example.com'
  c.example "Connects to a container:", 'ops ssh example.com www'
  c.action do |args, options|
    host = args[0]
    user = Ops::get_user_for(host)

    if args.count == 1
      ssh_port = 22
    else
      container = args[1]
      containers = Docker::containers_for(host)
      ssh_port = Docker::get_container_port containers[container]
    end
    command = "ssh #{user}@#{host} -p #{ssh_port}"

    puts "CMD: #{command}"
    exec command
  end
end
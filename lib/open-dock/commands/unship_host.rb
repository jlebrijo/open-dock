command :unship do |c|
  c.summary = 'Removes all Docker containers defined for the host in '#{Ops::CONTAINERS_DIR}/[host_name].yml'
  c.syntax = 'ops ship [host_name]'
  c.description = "Removes all Docker containers defined for the host in '#{Ops::CONTAINERS_DIR}/[host_name].yml"
  c.example "", 'ops unship example.com'
  c.action do |args, options|
    host = args[0]

    if host == "localhost"
      Docker::containers_for(host).each do |container_name, config|
        system "docker rm -f #{container_name}"
      end
    else
      user = Ops::get_user_for(host)

      Net::SSH.start(host, user) do |ssh|
        Docker::containers_for(host).each do |container_name, config|
          ssh.exec "docker rm -f #{container_name}"
        end
      end
    end
  end
end
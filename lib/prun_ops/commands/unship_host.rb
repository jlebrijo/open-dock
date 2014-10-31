command :'unship host' do |c|
  c.summary = 'Removes all Docker containers defined for the host in '#{Ops::CONTAINERS_DIR}/[host_name].yml'
  c.syntax = 'ops ship host [host_name]'
  c.description = "Removes all Docker containers defined for the host in '#{Ops::CONTAINERS_DIR}/[host_name].yml"
  c.example "", 'ops unship host example.com'
  c.action do |args, options|
    host = args[0]
    user = Ops::get_user_for(host)

    Net::SSH.start(host, user) do |ssh|
      Docker::containers_for(host).each do |container_name, config|
        ssh.exec "docker rm -f #{container_name}"
      end
    end
  end
end
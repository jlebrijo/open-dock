command :'unship host' do |c|
  c.summary = 'Removes all Docker containers defined for the host in '#{DigitalOcean::OPS_DIR}/containers/[host_name].yml'
  c.syntax = 'ops ship host [host_name]'
  c.description = "Removes all Docker containers defined for the host in '#{DigitalOcean::OPS_DIR}/containers/[host_name].yml"
  c.example "", 'ops unship host example.com'
  c.action do |args, options|
    host = args[0]

    Net::SSH.start(host, 'core') do |ssh|
      Docker::containers_for(host).each do |container_name, config|
        ssh.exec "docker rm -f #{container_name}"
      end
    end
  end
end
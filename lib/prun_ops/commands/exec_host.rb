command :'exec host' do |c|
  c.summary = 'Execute a command in host'
  c.description = "Execute a command in host defined by DNS_name"
  c.syntax = 'ops exec host [host_name] "[command]"'
  c.example "", "ops exec host example.com 'docker ps -a'"
  c.action do |args, options|
    host = args[0]

    Net::SSH.start(host, 'core') do |ssh|
      Docker::containers_for(host).each do |container_name, config|
        ssh.exec args[1]
      end
    end
  end
end
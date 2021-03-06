command :exec do |c|
  c.summary = 'Execute a command in host'
  c.description = "Execute a command in host defined by DNS_name"
  c.syntax = 'ops exec [host_name] "[command]"'
  c.example "List containers in host", "ops exec example.com 'docker ps -a'"
  c.action do |args, options|
    host = args[0]
    user = Ops::get_user_for(host)

    Net::SSH.start(host, user) do |ssh|
      Docker::containers_for(host).each do |container_name, config|
        ssh.exec args[1]
      end
    end
  end
end
command :ship do |c|
  c.summary = 'Create Docker containers defined in ops/containers/[host_name].yml'
  c.syntax = 'ops ship [host_name]'
  c.description = "Create all docker containers described in #{Ops::CONTAINERS_DIR}/[host_name].yml"
  c.example "Create a container called 'www' in the host example.com. This is described in '#{Ops::CONTAINERS_DIR}/example.com.yml' like:\n    #      www:\n    #        detach: true\n    #        image: jlebrijo/prun\n    #        ports:\n    #          - '2222:22'\n    #          - '80:80'", 'ops ship example.com'
  c.action do |args, options|
    host = args[0]
    user = Ops::get_user_for(host) unless host.include? "localhost"

    Docker::containers_for(host).each do |container_name, config|
      ports = config["ports"].map{|port| "-p #{port}"}.join(" ")
      options = []
      config.reject{|k| Docker::SPECIAL_OPTS.include? k}.each do |option, value|
        options << "--#{option}=#{value}"
      end
      say "Container '#{container_name}' loading on #{host}, please wait ....\n"
      command = "docker run #{options.join(" ")} --name #{container_name} #{ports} #{config["image"]} #{config["command"]}"
      say "Docker CMD: #{command}\n"
      if host.include? "localhost"
        system "#{command} ; #{Docker::copy_ssh_credentials_command(container_name)}"
      else
        Net::SSH.start(host, user) do |ssh|
          ssh.exec "#{command} ; #{Docker::copy_ssh_credentials_command(container_name)}"
        end
      end
      if config["post-conditions"]
        sleep 5
        config["post-conditions"].each { |c| system c }
      end
    end
  end
end
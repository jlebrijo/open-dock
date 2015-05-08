command :configure do |c|
  c.summary = 'Configure all Docker containers in a host using knife solo'
  c.syntax = 'ops configure [host_name]'
  c.description = "Configure all docker containers described in #{Ops::CONTAINERS_DIR}/[host_name].yml"
  c.option '--container CONTAINER_NAME', String, 'Only configure this container'
  c.example "Create a container called 'www' in the host example.com. This is described in '#{Ops::CONTAINERS_DIR}/example.com.yml' like:\n    #      www:\n    #        detach: true\n    #        image: jlebrijo/prun\n    #        ports:\n    #          - '2222:22'\n    #          - '80:80'\n    #      db:\n    #        detach: true\n    #        image: jlebrijo/prun-db\n    #        ports:\n    #          - '2223:22'\n    #          - '5432'\n    # Equivalent to run:\n    #      knife solo cook root@www.example.com -p 2222\n    #      knife solo cook root@db.example.com -p 2223'\n    # So you will need to create chef node files as 'nodes/[container_name].[host_name].json':\n    #      nodes/www.example.com.json\n    #      nodes/db.example.com.json", 'ops configure example.com'
  c.action do |args, options|
    options.default container: 'all'
    host = args[0]
    user = Ops::DEFAULT_USER
    containers = Docker::containers_for(host)

    if File.exists? "#{Ops::NODES_DIR}/#{host}.json" # Not a container ship
      Chef::install(user, host)
      Chef::cook(user, host)
    else
      if options.container == "all"
        containers.each do |container_name, config|
          ssh_port = Docker::get_container_port config
          Chef::cook_container(user,container_name, host, ssh_port)
        end
      else
        ssh_port = Docker::get_container_port containers[options.container]
        Chef::cook_container(user, options.container, host, ssh_port)
      end
    end
  end
end
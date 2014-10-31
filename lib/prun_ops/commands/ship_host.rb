command :'ship host' do |c|
  c.summary = 'Create Docker containers defined in ops/containers/[host_name].yml'
  c.syntax = 'ops ship host [host_name]'
  c.description = "Create all docker containers described in #{DigitalOcean::OPS_DIR}/containers/[host_name].yml"
  c.example "Create a container called 'www' in the host example.com. This is described in '#{DigitalOcean::OPS_DIR}/containers/example.com.yml' like:\n    #      www:\n    #        detach: true\n    #        image: jlebrijo/prun\n    #        ports:\n    #          - '2222:22'\n    #          - '80:80'", 'ops ship host example.com'
  c.action do |args, options|
    host = args[0]
    containers = Docker::containers_for host

    Net::SSH.start(host, 'core') do |ssh|
      containers.each do |container_name, config|
        ports = config["ports"].map{|port| "-p #{port}"}.join(" ")
        options = []
        config.reject{|k| Docker::ARGUMENTS.include? k}.each do |option, value|
          options << "--#{option}=#{value}"
        end
        say "\nContainer '#{container_name}' loading on #{host}, please wait ....\n"
        ssh.exec! "docker run #{options.join(" ")} --name #{container_name} #{ports} #{config["image"]} #{config["command"]}"

      end
    end
  end
end
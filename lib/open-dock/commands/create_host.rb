command :create do |c|
  c.summary = 'Create a droplet/host in your provider account'
  c.syntax = 'ops create [DNS_name]'
  c.description = "Creates the host described in the file #{Ops::HOSTS_DIR}/[DNS_name].yml"
  c.example "Create the host example.com in your DigitalOcean console. This is described in '#{Ops::HOSTS_DIR}/example.com.yml' like:\n    #      size:     512mb\n    #      region:   ams1\n    #      image:    coreos-stable\n    #      ssh_keys:\n    #        - e7:51:47:bc:7f:dc:2f:3c:56:65:28:e1:10:9c:88:57  xx:xx:xx:xx:xx:xx:xx", 'ops create example.com'
  c.action do |args, options|
    host = Host.new args[0]
    host.create
  end
end
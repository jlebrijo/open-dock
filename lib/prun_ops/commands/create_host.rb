command :'create host' do |c|
  c.summary = 'Create a droplet/host in your DO account'
  c.syntax = 'ops create host [DNS_name]'
  c.description = "Creates the host described in the file #{DigitalOcean::OPS_DIR}/hosts/[DNS_name].yml"
  c.example "Create the host example.com in your DigitalOcean console. This is described in '#{DigitalOcean::OPS_DIR}/hosts/example.com.yml' like:\n    #      size:     512mb\n    #      region:   ams1\n    #      image:    coreos-stable\n    #      ssh_keys:\n    #        - e7:51:47:bc:7f:dc:2f:3c:56:65:28:e1:10:9c:88:57  xx:xx:xx:xx:xx:xx:xx", 'ops create host example.com'
  c.action do |args, options|
    droplet = DigitalOcean::build_droplet args[0]
    cli = DigitalOcean::client
    resp = cli.droplets.create droplet
    if resp == droplet
      ip = cli.find_droplet_by_name(args[0]).networks["v4"].first.ip_address
      say "Droplet #{args[0]} (IP: #{ip}) succesfully created!"
    else
      raise resp
    end
  end
end
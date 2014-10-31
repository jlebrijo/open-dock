command :'delete host' do |c|
  c.summary = 'Delete a host in your DigitalOcean account'
  c.syntax = 'ops delete host [DNS_name]'
  c.description = "Delete the host, based on DNS_name, which (not need but) should be described in its #{DigitalOcean::OPS_DIR}/hosts/[DNS_name].yml file  "
  c.example 'Delete the host example.com in your DigitalOcean console', 'ops delete host example.com'
  c.action do |args, options|
    cli = DigitalOcean::client
    id = cli.find_droplet_by_name(args[0]).id
    resp = cli.droplets.delete id: id
    if resp.is_a?(TrueClass)
      say "Droplet #{args[0]} succesfully deleted!"
    else
      raise resp
    end
  end
end
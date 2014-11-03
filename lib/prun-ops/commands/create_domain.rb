command :'create domain' do |c|
  c.summary = 'Create a domain in your DigitalOcean account'
  c.syntax = 'ops create domain [domain name] [ip address]'
  c.description = "Create the domain with #{DigitalOcean::CONFIG_FILE} credentials"
  c.example 'Create the domain example.com in your DigitalOcean console', 'ops create domain example.com'
  c.action do |args, options|
    ip = (args[1].nil?)? '1.1.1.1':args[1]
    domain = DropletKit::Domain.new(ip_address: ip, name: args[0])
    resp = DigitalOcean::client.domains.create domain
    if domain == resp
      say "Domain #{resp.name} succesfully created!"
    else
      raise resp
    end
  end
end
command :'delete domain' do |c|
  c.summary = 'Delete a domain in your DigitalOcean account'
  c.syntax = 'ops delete domain [domain name]'
  c.description = "Delete the domain with #{DigitalOcean::CONFIG_FILE} credentials"
  c.example 'Delete the domain example.com in your DigitalOcean console', 'ops delete domain example.com'
  c.action do |args, options|
    resp = DigitalOcean::client.domains.delete name: args[0]
    if resp.is_a?(TrueClass)
      say "Domain #{args[0]} succesfully deleted!"
    else
      raise resp
    end
  end
end
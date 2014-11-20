command :delete do |c|
  c.summary = 'Delete a host in your provider account'
  c.syntax = 'ops delete [DNS_name]'
  c.description = "Delete the host, based on DNS_name, which (not need but) should be described in its #{Ops::HOSTS_DIR}/[DNS_name].yml file  "
  c.example 'Delete the host example.com in your DigitalOcean console', 'ops delete example.com'
  c.action do |args, options|
    host = Host.new args[0]
    host.delete
  end
end
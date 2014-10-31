command :'provision host' do |c|
  c.summary = 'Create and ship the host based on config files'
  c.syntax = 'ops provision host [host_name]'
  c.description = "Agregate both commands Create and Ship host"
  c.example "Creates and ships example.com host", 'ops provisiion host example.com'
  c.action do |args, options|
    system "#{program :name} create host #{args.join(" ")}"
    sleep 15
    system "#{program :name} ship host #{args.join(" ")}"
  end
end
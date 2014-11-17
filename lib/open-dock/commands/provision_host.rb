command :provision do |c|
  c.summary = 'Create and ship the host based on config files'
  c.syntax = 'ops provision [host_name]'
  c.description = "Agregate both commands Create and Ship host"
  c.example "Creates and ships example.com host", 'ops provisiion example.com'
  c.action do |args, options|
    system "#{program :name} create #{args.join(" ")}"
    sleep 15
    system "#{program :name} ship #{args.join(" ")}"
  end
end
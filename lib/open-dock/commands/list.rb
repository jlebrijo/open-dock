command :list do |c|
  c.summary = 'List all droplet creation parameters'
  c.syntax = 'ops list |provider|'
  c.description = "List all possible providers, and all possible params for a provider if |provider| is defined"
  c.example "List all possible providers", "ops list"
  c. example "List all possible arguments for DigitalOcean", "ops list digital_ocean"
  c.action do |args, options|
    if args[0]
      say "\nDESCRIPTION: This shows a list in the format '- [id] =>  [description]'. Use [id] values to create your host file in #{Ops::HOSTS_DIR}/[dns_name].yml\n"
      ProviderFactory.build(args[0]).list_params
    else
      ProviderFactory.list_providers
    end

  end
end
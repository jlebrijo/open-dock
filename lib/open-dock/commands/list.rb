command :list do |c|
  c.summary = 'List all droplet creation parameters'
  c.syntax = 'ops list'
  c.description = "This shows a list in the format '- [id] =>  [description]'. Use [id] values to create your host file in #{Ops::DIR}/hosts/[dns_name].yml "
  c.action do |args, options|
    cli = DigitalOcean::client
    say "\nDESCRIPTION: #{c.description}\n"

    say "\nSizes:"
    cli.sizes.all.each do |i|
      say "   - #{i.slug.ljust(6)} =>   $#{i.price_monthly}/mo"
    end

    say "\nRegions:"
    cli.regions.all.each do |i|
      say "   - #{i.slug.ljust(6)} =>   #{i.name}"
    end

    say "\nImages:"
    cli.images.all.each do |i|
      say "   - #{i.slug.ljust(20)} =>   #{i.distribution} #{i.name}" unless i.slug.nil?
    end

    say "\nSSH Keys:"
    cli.ssh_keys.all.each do |i|
      say "   - #{i.fingerprint} =>   #{i.name}"
    end
  end
end
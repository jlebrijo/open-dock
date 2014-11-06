# PrunOps

Covers all Operations in a Ruby on Rails Application server:

1. PROVISION: Create hosts and ship them with Docker containers.
1. CONFIGURATION: Build Chef cookbooks and configure/re-configure your servers. Based on [PRUN-CFG cookbook](https://1upermarket.getchef.com/cookbooks/prun-cfg).
1. DEPLOYMENT: Capistrano tasks to depoly your rails Apps.
1. DIAGNISIS: Capistrano diagnosis tools to guet your Apps status on real time.
1. RELEASE: Rake tasks to manage and tag version number in your Apps (X.Y.Z).
1. BACKUP: Backup policy for database and files in your Apps, using git as storage.

Based on [PRUN docker image](https://registry.hub.docker.com/u/jlebrijo/prun/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prun-ops'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prun-ops

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/prun-ops/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

[MIT License](http://opensource.org/licenses/MIT). Copyright 2009-2014 at [Lebrijo.com](http://lebrijo.com)
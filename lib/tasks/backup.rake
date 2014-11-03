namespace :db do

  desc "Backup the database from tmp/db.sql file if no one is passed"
  task backup: :get_config do
    sh "export PGPASSWORD=#{@password} && pg_dump #{@database} -U #{@username} -f #{filename}"
  end

  desc "Restore the database from tmp/db.sql file if no one is passed"
  task restore: [:drop, :create, :get_config] do
    sh "export PGPASSWORD=#{@password} && psql -d #{@database} -U #{@username} < #{filename}"
  end
end

task :get_config do
  config   = Rails.configuration.database_configuration
  @environment = Rails.env
  @database = config[@environment]["database"]
  @username = config[@environment]["username"]
  @password = config[@environment]["password"]
end

def filename
  name = ARGV[1]
  task name.to_sym do ; end unless name.nil?
  return name ? name : "tmp/db.sql"
end




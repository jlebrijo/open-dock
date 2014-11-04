namespace :db do
  desc 'Pull db'
  task :pull do
    on roles(:app) do |host|
      within "#{current_path}/tmp" do
        with rails_env: :production do
          rake "db:backup"
        end
      end
      run_locally do
        execute "scp -P #{host.port} #{host.user}@#{host.hostname}:#{current_path}/tmp/db.sql tmp/"
        rake "db:restore tmp/db.sql"
      end
    end

  end
end

namespace :files do
  desc 'Pull files uploaded'
  task :pull do
    on roles(:app) do |host|
      run_locally do
        execute "scp -r -P #{host.port} #{host.user}@#{host.hostname}:#{current_path}/public/uploads public/"
      end
    end
  end
end
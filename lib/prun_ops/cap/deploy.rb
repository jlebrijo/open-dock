namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "service thin restart"
    end
  end

  after :publishing, :restart
end


namespace :db do
  desc 'First DDBB setup'
  task :setup do
    on roles(:all) do
      within release_path do
        with rails_env: fetch(:stage) do
          execute :rake, 'db:schema:load'
          execute :rake, 'db:seed'
        end
      end
    end
  end
end

namespace :git do
  desc 'Git pull for common code project'
  task :pull_common do
    on roles(:app) do
      within "/var/www/common" do
        execute :git, :pull, :origin, :master
      end if test("[ -f /var/www/common ]")
    end
  end

  after "deploy:updating", "git:pull_common"
end


#####  Common tasks

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

namespace :ops do
  task :ssh do
    on roles(:app) do |host|
      run_locally do
        exec "ssh #{host.user}@#{host.hostname} -p #{host.port}"
      end
    end
  end
  task :c do
    on roles(:app) do
      within "#{current_path}" do
        exec "rails c"
      end
    end
  end
  task :log do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:stage)}.log"
    end
  end
end

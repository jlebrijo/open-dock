require "prun-ops/cap/diagnosis"
require "prun-ops/cap/backup"

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

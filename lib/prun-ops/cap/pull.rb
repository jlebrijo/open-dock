namespace :pull do
  desc 'Pull data (db/files) from remote (i.e: production) application.'
  task :data do
    invoke "pull:files"
    invoke "pull:db"
  end

  desc 'Pull db'
  task :db do
    on roles(:app) do |host|
      debug ":   Pulling database from #{fetch(:stage)} ..."
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

  desc 'Pull files uploaded'
  task :files do
    on roles(:app) do |host|
      run_locally do
        debug ":   Pulling Files from #{fetch(:stage)} ..."
        if fetch(:backup_dirs).any?
          fetch(:backup_dirs).each do |dir|
            execute "scp -r -P #{host.port} #{host.user}@#{host.hostname}:#{current_path}/#{dir} #{dir}"
          end
        else
          error ":    Set key :backup_dirs to know which ones to pull"
        end

      end
    end
  end
end
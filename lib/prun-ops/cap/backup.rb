namespace :backup do
  desc 'Restore data from git repo, last backup by default'
  task :restore, :tag do |task, args|
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:stage) do
          execute :rake, "backup:restore #{args[:tag]}"
        end
      end
    end

  end
end
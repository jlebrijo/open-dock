desc 'SSH connection with server'
task :ssh do
  on roles(:app) do |host|
    run_locally do
      run_in host, ""
    end
  end
end

desc 'Opens a remote Rails console'
task :c do
  on roles(:app) do |host|
    run_locally do
      run_in host, "cd #{current_path} && RAILS_ENV=#{fetch(:stage)} bundle exec rails c"
    end
  end
end

desc 'Tails the environment log or the log passed as argument: cap log[thin.3000.log]'
task :log, :file do |task, args|
  on roles(:app) do
    file = args[:file]? args[:file] : "#{fetch(:stage)}.log"
    execute "tail -f #{shared_path}/log/#{file}"
  end
end

desc "Runs a command in server: cap production x['free -m']"
task :x, :command do |task, args|
  on roles(:app) do |host|
    run_locally do
      run_in host, args[:command]
    end
  end
end

def run_in(host, cmd)
  exec "ssh #{host.user}@#{host.hostname} -p #{host.port} -tt '#{cmd}'"
end
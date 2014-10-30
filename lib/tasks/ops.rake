namespace :http do
  desc "Starts a simple HTTP server in port 8000:  rake http:s [folder]"
  task :s do
    folder = ARGV[1] ? ARGV[1] : '.'
    sh "ruby -run -e httpd #{folder} -p 8000"
  end
end

desc "Reset DataBase for environment and test"
namespace :db do
  task :reset do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    sh "rake db:test:prepare"
  end
end
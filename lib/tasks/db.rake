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

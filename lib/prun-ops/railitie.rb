require 'prun-ops'
require 'rails'
module PrunOps
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/backup.rake"
      load "tasks/db.rake"
      load "tasks/git.rake"
      load "tasks/http.rake"
      load "tasks/version.rake"
    end
  end
end
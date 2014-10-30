require 'prun_ops'
require 'rails'
module PrunOps
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/backup.rake"
      load "tasks/version.rake"
      load "tasks/ops.rake"
    end
  end
end
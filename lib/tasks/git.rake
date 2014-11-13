namespace :git do

  desc "Merge dev forward master branch"
  task :ff do
    sh "git checkout master && git merge dev && git push && git checkout dev"
  end

end
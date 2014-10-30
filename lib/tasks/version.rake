desc "Version control"
namespace :version do
  desc "Release a version: rake version:release version_tag"
  task :release, :number do  |t, args|
    version_tag = get_version_tag
    # Merge dev/master and push
    sh "git show-branch dev" do |ok, res|
      if ok
        sh "git checkout master && git merge dev && git push && git checkout dev"
      else
        sh "git push"
      end
    end

    # Tagging
    sh "git tag -a #{version_tag} -m 'Version #{version_tag} - #{Time.now.to_date}'"
    sh "git push origin --tags"
  end

  desc "Delete a version: rake version:remove version_tag "
  task :remove, :number do  |t, args|
    version_tag = get_version_tag
    sh "git tag -d #{version_tag}"
    sh "git push origin :refs/tags/#{version_tag}"
  end

  def get_version_tag
    if ARGV[1].nil?
      puts "We need a version tag: $ rake version:release version_tag"
      raise
    else
      ARGV[1]
    end
  end

end
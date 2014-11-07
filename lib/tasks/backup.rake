namespace :backup do
  desc 'Restore and database and :backup_dirs from the git :backup_repo, with the TAG given'
  task restore: :get_config do
    pull_repo(tag)
    sh "rake db:restore #{@backup_path}/db.sql"
    @asset_folders.each do |folder|
      dest_folder = "#{Rails.root}/#{folder}"
      sh "mkdir -p #{dest_folder}" unless File.directory?(dest_folder)
      sh "cp -r #{@backup_path}/#{folder}/* #{dest_folder}"
    end
  end
end

desc 'Commits and tag the database dump and :backup_dirs into a git :backup_repo'
task backup: ["db:backup", :get_config] do
  pull_repo

  # Gather data
  sh "mv #{@dump_file} #{@backup_path}"

  @asset_folders.each do |folder|
    dest_folder = "#{@backup_path}/#{folder}"
    sh "mkdir -p #{dest_folder}" unless File.directory?(dest_folder)
    sh "cp  -Lr #{Rails.root}/#{folder}/* #{dest_folder}"
  end

  # Pushing data
  comment = "#{@app_name} backup at #{Time.now.strftime "%F %R"}"
  sh "git add --all && git commit -m '#{comment}'" do |ok, res|
    if ! ok
      puts "Nothing change since last backup"
    else
      sh "git push origin master"
    end
  end

  # Tagging
  tagname = if tag.blank?
              "#{@app_name}-#{Date.today.strftime "%Y%m%d" }"
            else
              tag
            end
  sh "git tag -a #{tagname} -m '#{comment}' -f"
  sh "git push origin #{tagname}"
end

task :get_config do
  @environment = Rails.env

  @app_name = Rails.application.class.parent_name.parameterize
  tmp_dir = "#{Rails.root}/tmp"
  @repo_path = "#{tmp_dir}/backup"
  @backup_path = "#{@repo_path}/#{@app_name}"
  @dump_file = "#{tmp_dir}/db.sql"
  @git_repo = Rails.configuration.backup_repo
  @asset_folders = Rails.configuration.backup_dirs
end

def tag
  name = ARGV[1]
  task name.to_sym do ; end unless name.nil?
  return name
end

def pull_repo(tag="")
  if File.directory?(@repo_path)
    cd "#{@repo_path}"
    sh "git pull origin master"
  else
    sh "git clone #{@git_repo} #{@repo_path}"
    cd "#{@repo_path}"
  end
  sh "git checkout tags/#{tag}" unless tag.blank?
end
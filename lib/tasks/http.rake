namespace :http do
  desc "Starts a simple HTTP server in port 8000:  rake http:s [folder]"
  task :s do
    folder = ARGV[1] ? ARGV[1] : '.'
    sh "ruby -run -e httpd #{folder} -p 8000"
  end
end
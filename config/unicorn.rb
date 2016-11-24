#worker_processes 3
#preload_app true
#timeout 30
#listen 5001
#rails_root  = `pwd`.gsub("\n", "")
#rails_root = "/home/aceimdiplomados/aceim_diplomados"
#pid         "#{rails_root}/tmp/pids/unicorn.pid"
#stderr_path "#{rails_root}/log/unicorn.log"
#stdout_path "#{rails_root}/log/unicorn.log"

#after_fork do |server, worker|
#  ActiveRecord::Base.establish_connection
#end



# set path to application
# app_dir = File.expand_path("../..", __FILE__)
app_dir = "/home/aceimdiplomados/aceim_diplomados"
shared_dir = "#{app_dir}/shared"
working_directory app_dir


# Set unicorn options
worker_processes 3
preload_app true
timeout 30

# Set up socket location
listen 5001 #"#{shared_dir}/sockets/unicorn.sock", :backlog => 64

# Logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "#{shared_dir}/pids/unicorn.pid"

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end


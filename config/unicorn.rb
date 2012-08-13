worker_processes 3
preload_app true
timeout 30
listen 5001
#rails_root  = `pwd`.gsub("\n", "")
rails_root = "/home/aceimdiplomados/aceim_diplomados"
pid         "#{rails_root}/tmp/pids/unicorn.pid"
#stderr_path "#{rails_root}/log/unicorn.log"
#stdout_path "#{rails_root}/log/unicorn.log"

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end

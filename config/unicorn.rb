worker_processes 2

preload_app true

timeout 30

listen 3000

working_directory "/app"

pid "/var/run/unicorn.pid"
stderr_path "/var/log/unicorn.log"
stdout_path "/var/log/unicorn.log"

=begin
before_fork do |server, worker|
  # Disconnect from db before forking (won't carry over)
  if defined? ActiveRecord::Base
    ActiveRecord::Base.connection.disconnect!
  end

  if defined?(Resque)
    Resque.redis.quit
  end
end

after_fork do |server, worker|
  # Start up db connection again
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  if defined?(Resque)
    Resque.redis = ENV['REDIS_URL']
  end
end
=end
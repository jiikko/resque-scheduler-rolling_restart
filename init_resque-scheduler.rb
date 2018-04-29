require 'resque-scheduler-failover'
require 'yaml'

Resque.redis = ENV['REDIS_URL'] || 'redis://localhost:6379/'
Resque.schedule = YAML.load_file("config/resque_schedule.yml")

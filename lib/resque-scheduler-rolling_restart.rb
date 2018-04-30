require 'resque-scheduler'
require 'resque/scheduler/rolling_restart'
require 'resque/scheduler/ext/locking'
require "resque/scheduler/rolling_restart/version"

module Resque
  module Scheduler
    class << self
      prepend Resque::Scheduler::RollingRestart
    end
  end
end

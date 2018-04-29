require 'resque-scheduler'
require 'resque/scheduler/failover'
require 'resque/scheduler/ext/locking'
require "resque/scheduler/failover/version"

module Resque
  module Scheduler
    class << self
      prepend Resque::Scheduler::Failover
    end
  end
end

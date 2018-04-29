module Resque
  module Scheduler
    class << self
      def before_shutdown
        log('starting overrided before_shutdown by resque-schedulebr-failover')
        if master?
          release_master_lock
          log('done release_master_lock from master')
          loop do
            # TODO do not execute break if single process
            break if master_lock.locked?
            sleep(1)
          end
          log('found next master')
          stop_rufus_scheduler
        else
          super
          log('done before_shutdown from next master')
        end
      end
    end
  end
end

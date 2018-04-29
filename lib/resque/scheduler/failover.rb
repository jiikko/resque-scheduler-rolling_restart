module Resque
  module Scheduler
    module Failover
      def before_shutdown
        log('starting overrided before_shutdown by resque-schedulebr-failover')
        if master?
          release_master_lock
          log('done release_master_lock from master')
          sleep(10)
          loop do
            # TODO do not execute break if single process
            # TODO next master も 自分になる件について
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

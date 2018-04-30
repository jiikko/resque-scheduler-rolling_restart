module Resque
  module Scheduler
    module RollingRestart
      module Status
        def waiting_for_next_master?
          self.current_status == :waiting_for_next_master
        end

        def found_next_master?
          self.current_status == :found_next_master
        end

        def running?
          self.current_status == :running
        end

        def updat_status!(status)
          @@status = status
        end

        def current_status
          @@status ||= :running
        end
      end
      include Status

      def master?
        case
        when waiting_for_next_master?
          true
        when found_next_master?
          false
        when running?
          super
        end
      end

      def handle_shutdown
        exit if @shutdown && found_next_master?
        yield
        exit if @shutdown && found_next_master?
      end

      def poll_sleep
        v = super
        if @shutdown
          @waiting_for_next_master = true
        end
        if waiting_for_next_master? && master_lock.locked_by_other_master?
          updat_status!(:found_next_master)
        end
          v
        end

      def before_shutdown
        log('starting overrided before_shutdown by resque-schedulebr-rolling_restart')
        if master_lock.locked?
          release_master_lock
          updat_status!(:waiting_for_next_master)
        else
          super
          updat_status!(:found_next_master)
          log('done before_shutdown from next master')
        end
      end
    end
  end
end

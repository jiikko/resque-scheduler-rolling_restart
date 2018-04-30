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
          log("[#{`hostname`.strip}] change to #{status}")
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
        val = super
        if waiting_for_next_master? && master_lock.locked_by_other_master?
          updat_status!(:found_next_master)
        end
        val
      end

      def before_shutdown
        if master?
          release_master_lock
          updat_status!(:waiting_for_next_master)
        else
          super
          updat_status!(:found_next_master)
        end
      end
    end
  end
end

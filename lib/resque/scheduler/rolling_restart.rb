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

        def loaded_schedule_at_next_master?
          self.current_status == :loaded_schedule_at_next_master
        end

        def update_status!(status)
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

      def load_schedule!
        super
        # #{set loaded_values to redis} if running? && master?
      end

      def handle_shutdown
        exit if @shutdown && found_next_master?
        yield
        exit if @shutdown && found_next_master?
      end

      def poll_sleep
        val = super
        if waiting_for_next_master? && master_lock.locked_by_other_master?
          update_status!(:found_next_master)
          Resque::Scheduler.poll_sleep_amount = 0.3
        end
        # if found_next_master? && #{get loaded_values to redis}
        #   update_status(:loaded_schedule_at_next_master?)
        #   del loaded_values from redis
        # end
        val
      end

      def before_shutdown
        if master?
          release_master_lock
          update_status!(:waiting_for_next_master)
        else
          super
          update_status!(:found_next_master)
        end
      end
    end
  end
end

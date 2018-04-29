module Resque
  module Scheduler
    module Lock
      class Base
        def locked_by_other_master?
          stored_value = Resque.data_store.get(key)
          case
          when stored_value.nil?
            return false
          when stored_value == value
            log!('invalid!!ロックを開放しているはずなので自分でロックしているのはおかしい')
            return false
          when stored_value != value
            return true
          end
        end
      end
    end
  end
end

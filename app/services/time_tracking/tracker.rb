module TimeTracking
  class Tracker
    delegate :project_tracked_time, to: :@wrapper

    def initialize(service)
      case service 
        when 'toggl' then @wrapper = TimeTracking::Providers::Toggl.new
        when 'harvest' then @wrapper = TimeTracking::Providers::Harvest.new   
        else raise "Invalid tracking service"
      end
    end
  end
end

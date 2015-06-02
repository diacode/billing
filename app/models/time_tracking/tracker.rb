# TODO: Move the whole module to /app/services
module TimeTracking
  class Tracker
    delegate :project_tracked_time, to: :@wrapper

    def initialize(service)
      case service 
        when 'toggl' then @wrapper = TimeTracking::Services::Toggl.new
        when 'harvest' then @wrapper = TimeTracking::Services::Harvest.new   
        else raise "Invalid tracking service"
      end
    end
  end
end
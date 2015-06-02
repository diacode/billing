module TimeTracking
  module Services
    class Base
      def get(path, params)
        response = @connection.get path, params
        JSON.parse(response.body)
      end
      
      def project_total_time(project)
        raise "Subclass Responsibility"
      end
    end
  end
end
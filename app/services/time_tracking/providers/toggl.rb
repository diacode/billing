module TimeTracking
  module Providers
    class Toggl < Base
      def initialize
        @api_key = ::BillingConfig['time_tracking']['api_key']
        @workspace = ::BillingConfig['time_tracking']['workspace'].to_s

        @connection = Faraday.new(url: 'https://toggl.com/reports/api/v2') do |faraday|
          faraday.request  :url_encoded
          faraday.adapter  Faraday.default_adapter
          faraday.response :logger, Logger.new('faraday.log')
          faraday.headers = {'Content-Type' => 'application/json'}
          faraday.basic_auth @api_key, 'api_token' # this needs to be after headers
        end
      end

      # If any range is supplied we try to retrieve the hours spent of all time.
      # Toggl restricts his API up to 1 year as maximum range.
      def project_tracked_time(id, a = 365.days.ago.to_date, b = Date.today)
        response = get(
          'summary',
          default_call_params.merge(
            :since => a.strftime("%Y-%m-%d"),
            :until => b.strftime("%Y-%m-%d"),           
            :project_ids => id
          )
        )
        
        (response['total_grand'].to_f/1000/60/60).round(2)
      end

      def default_call_params
        {
          user_agent: 'diacode-billing-app',
          workspace_id: @workspace
        }
      end
    end
  end
end

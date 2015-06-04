module ChatNotifications
  class ChatNotifications

    def initialize
      case ::BillingConfig['notifications']['provider']
        when 'hipchat' then @wrapper = ChatNotifications::Providers::Hipchat.new
        when 'slack' then @wrapper = ChatNotifications::Providers::Slack.new   
      end
    end
    
    def notify(message)
      # notify only if we have a notifcation provider
      @wrapper.notify(message) if @wrapper
    end

    def notify_bank_record(bank_record)
      router = Router.new
      balance_link = "<a href=\"#{router.bank_records_url}\">#{bank_record.subject}</a>"
      amount = ActionController::Base.helpers.number_to_currency(bank_record.amount, locale: :es)
      notify("*Nuevo movimiento bancario:* #{balance_link} (#{amount})")
    end

  end
end

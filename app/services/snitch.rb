# TODO: This should notify depending on configuration settings

# This class sends notifications
class Snitch
  ROOM = ENV['HIPCHAT_ROOM']

  def self.notify_bank_record(bank_record)
    router = Router.new
    balance_link = "<a href=\"#{router.bank_records_url}\">#{bank_record.subject}</a>"
    amount = ActionController::Base.helpers.number_to_currency(bank_record.amount, locale: :es)
    notify("*Nuevo movimiento bancario:* #{balance_link} (#{amount})")
  end

  #private
    def self.notify(message)
      begin
        # HipChatClient[ROOM].send('Facturación', message, notify: true)
        SlackNotifier.ping(message)
      rescue => ex
        Rails.logger.error ex
        false
      end
    end
end
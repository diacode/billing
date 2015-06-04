class ChatNotifications::Providers::Slack
  WEBHOOK_URL = ::BillingConfig['notifications']['webhook_url']
  USERNAME = ::BillingConfig['notifications']['username']
  EMOJI = ::BillingConfig['notifications']['emoji']

  def notify(message)
    begin
      client.ping(message)
    rescue => ex
      Rails.logger.error ex
      false
    end
  end

  def client
    Slack::Notifier.new WEBHOOK_URL, username: USERNAME, icon_emoji: EMOJI
  end
end

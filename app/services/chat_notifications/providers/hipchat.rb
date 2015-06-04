class ChatNotifications::Providers::Hipchat
  TOKEN = ::BillingConfig['notifications']['token']
  ROOM = ::BillingConfig['notifications']['room']
  USERNAME = ::BillingConfig['notifications']['username']

  def notify(message)
    begin
      client.send(USERNAME, message, notify: true)
    rescue => ex
      Rails.logger.error ex
      false
    end
  end

  def client
    HipChat::Client.new(TOKEN, api_version: 'v2')
  end
end

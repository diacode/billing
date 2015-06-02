# Class we'll use to create routes outside views 
# without including anything
class Router
  include Rails.application.routes.url_helpers

  def self.default_url_options
    ActionMailer::Base.default_url_options
  end
end
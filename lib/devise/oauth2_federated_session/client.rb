class Devise::Oauth2FederatedSession::Client < Devise::Oauth2Providable::Client
  
  attr_accessible :session_expired_notification_uri
  
  before_create { self.uses_account_sid = true }
  
  #
  # This method could be used to validate redirection URIs
  # supplied in client requests, to make sure that the provider doesn't 
  # redirect the user to an unknown host.
  #
  def valid_redirect_uri?(redirect_uri)
    true
  end
  
end
class Devise::Oauth2FederatedSession::Client < Devise::Oauth2Providable::Client
  
  attr_accessible :session_expired_notification_uri
  
  #
  # The following filter will set the client as a a federated session client
  # that uses an account session id.
  # If you use Devise::Oauth2Providable::Client, the default value of
  # uses_account_sid is false.
  #
  before_create { self.uses_account_sid = true }
  
  #
  # This method is used to validate the redirection URIs
  # supplied in client requests. This way, the provider doesn't 
  # redirect the user to an unknown host.
  #
  # The current implementation always trust the redirect_uri because
  # there are no security risks where it's used. In the future, it can
  # be extended to support a proper validation.
  #
  def valid_redirect_uri?(redirect_uri)
    true
  end
  
end
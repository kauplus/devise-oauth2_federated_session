#
# Clean up the session when the user logs out.
#
Warden::Manager.before_logout do |user, auth, opts|
  
  if user
    
    # These tokens will be expired
    tokens = Devise::Oauth2Providable::AccessToken.where(
      :user_id => user.id, 
      :account_sid => auth.env['rack.session']['session_id'], 
      :session_expired_at => nil)
    
    Devise::Oauth2FederatedSession::Session.cleanup(tokens)
    
  end
  
end
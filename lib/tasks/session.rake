namespace :devise_oauth2_federated_session do
  
  namespace :sessions do
    
    desc "Expires access tokens older than config.devise_oauth2_federated_session.expire_sessions_in"
    task :expire => :environment do
      date_limit = Time.now.utc - Rails.application.config.devise_oauth2_federated_session.expire_sessions_in
      tokens = Devise::Oauth2Providable::AccessToken.where("created_at < ? AND account_sid IS NOT NULL AND session_expired_at IS NULL", date_limit)
      Devise::Oauth2FederatedSession::Session.cleanup(tokens)
    end
    
  end
  
end
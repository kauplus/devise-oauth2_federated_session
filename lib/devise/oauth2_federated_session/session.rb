module Devise
  
  module Oauth2FederatedSession
    
    class Session
    
      def self.cleanup(tokens)
        
        # Notify all clients that their tokens have been expired
        Devise::Oauth2FederatedSession.client_notifier.notify_expired_session(tokens)
      
        # Remove tokens from the cache
        tokens.each do |t|
          Rails.cache.delete("#{Rails.application.config.devise_oauth2_federated_session.cache_prefix}_#{t.token}")
        end
      
        # Mark tokens as expired
        tokens.update_all(:session_expired_at => DateTime.now)
        
      end
      
    end
    
  end
  
end
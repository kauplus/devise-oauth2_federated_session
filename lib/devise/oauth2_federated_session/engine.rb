module Devise
  
  module Oauth2FederatedSession
    
    class Engine < Rails::Engine
      
      engine_name 'oauth2_federated_session'
      isolate_namespace Devise::Oauth2FederatedSession
      
      # Configuration options (can be overriden by the host application).
      
      config.devise_oauth2_federated_session = ActiveSupport::OrderedOptions.new
      
      config.devise_oauth2_federated_session.expire_sessions_in = 1.day
      config.devise_oauth2_federated_session.cache_prefix = '_account_sid'
      config.devise_oauth2_federated_session.use_client_notification = true
      
    end
    
  end
  
end
module Devise
  
  module Oauth2FederatedSession
    
    class DeviseSessionsController < Devise::SessionsController
      
      alias :devise_after_sign_out_path_for :after_sign_out_path_for
      
      #
      # Override default sign out behaviour, so that clients can log users out 
      # and have them be redirected back to the some client page.
      #
      def after_sign_out_path_for(resource_name)
        client = Oauth2FederatedSession::Client.find_by_identifier(params[:client_id])
        
        if client && params[:redirect_uri].present? && client.valid_redirect_uri?(params[:redirect_uri])
          params[:redirect_uri]
        else
          devise_after_sign_out_path_for(resource_name)
        end
      end
      
    end
    
  end
  
end
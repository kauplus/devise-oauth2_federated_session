module Devise
  
  module Oauth2FederatedSession
    
    #
    # Deals with issuing and validating access tokens.
    #
    class SessionsController < Devise::Oauth2Providable::TokensController
      
      skip_before_filter :authenticate_user!, :only => :recognize_user
      
      delegate :new_user_session_path, to: 'Rails.application.routes.url_helpers'
      delegate :recognize_user_path, to: 'Devise::Oauth2FederatedSession::Engine.routes.url_helpers'

      delegate :cache_prefix, to: 'Rails.application.config.devise_oauth2_federated_session'
      
      #
      # GET /:mounted_path/sessions/create
      #
      # Creates a new access token given an authorization code.
      # The token creation is done by the superclass and then this method
      # sets relevant information that will enable the access token to be
      # used for session management.
      #
      def create
        super
        
        if @access_token.client.uses_account_sid
          # Never expire this token. It will be expired when the user explicitly
          # ends their session (by logging out), and possibly after a configurable
          # amount of time, if the provider is using expiration scheduling
          # (see the sessions:expire rake task).
          @access_token.expires_at = Time.mktime(2100, 12, 31)
        end
        
        authorization_code = Oauth2Providable::AuthorizationCode.find_by_token(params[:code])
        @access_token.account_sid = authorization_code.account_sid
        @access_token.save
      end
      
      #
      # GET /:mounted_path/sessions/is_alive
      #
      def is_alive
        token = env[Oauth2Providable::ACCESS_TOKEN_ENV_REF]
        session_alive = Rails.cache.read("#{cache_prefix}_#{token}")
        
        unless session_alive
          
          access_token = Oauth2Providable::AccessToken.find_by_token(token)
          
          if access_token.session_expired_at.nil?
            Rails.cache.write("#{cache_prefix}_#{access_token.token}", true)
            session_alive = true
          else
            session_alive = false
          end

        end
        render :text => session_alive
      end
      
      #
      # GET /:mounted_path/sessions/recognize_user
      #
      # This action can be used by clients when the client session is first created
      # and the it wishes to know if the user is already logged in, so that it
      # can also log them in its own application.
      #
      # Two cases are supported:
      # 1) Authentication is not mandatory: if the user is already logged in, the client
      # will be sent an authorization code to be able to start a new session; if the
      # user is not logged in, they will be redirected to the location specified
      # by the :redirect_uri parameter.
      # 2) Authentication is mandatory: if the user is already logged in, the client
      # will be sent an authorization code to be able to start a new session; if the
      # user is not logged in, they will be shown the login page.
      #
      def recognize_user
        rack_response = oauth2_authorizer.call(request.env)
        redirect_to rack_response.last.header['Location']
      end
      
      protected
      
      def oauth2_authorizer
        
        Rack::OAuth2::Server::Authorize.new do |req, res|
          
          client = Devise::Oauth2FederatedSession::Client.find_by_identifier(req.client_id) || req.bad_request!
          
          if current_user
            res.redirect_uri = @redirect_uri = client.redirect_uri
            
            if client.uses_account_sid && req.response_type.eql?(:code)
              authorization_code = current_user.authorization_codes.create!(
                :client => client, 
                :account_sid => request.env['rack.session']['session_id'])
              res.code = authorization_code.token
              res.approve!
            else
              req.bad_request!
            end
            
          elsif params[:redirect_uri].present? && client.valid_redirect_uri?(params[:redirect_uri])
            # Client does not require authentication. Send the user back.
            res.redirect req.verify_redirect_uri!(params[:redirect_uri])
          else
            # Client requires authentication.
            # Ask the user to log in and return here aftwerwards.
            session[:user_return_to] = recognize_user_path(:response_type => :code, :client_id => client.identifier)
            res.redirect new_session_path(:user)
          end
          
        end
        
      end
      
    end
    
  end
  
end
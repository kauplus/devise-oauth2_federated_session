module Devise
  
  module Oauth2FederatedSession
    
    #
    # Deals with issuing authorization codes for clients.
    # Clients will be able to exchange these codes for access tokens when
    # creating a new session (see SessionsController).
    #
    class AuthorizationsController < Devise::Oauth2Providable::AuthorizationsController
      
      #
      # GET /:mounted_path/authorize
      #
      # Issues a short-lived authorization code for known clients. If the client
      # uses federated session management, the user will not be shown the usual
      # screen asking for their permission; the client will be considered automatically
      # approved.
      #
      def new
        unless (client = Oauth2Providable::Client.find_by_identifier(params[:client_id]))
          raise Rack::OAuth2::Server::Authorize::BadRequest
        end
        
        if client.uses_account_sid
          params[:approve] = true
          respond *authorize_endpoint(:allow_approval).call(request.env)
        else
          respond *authorize_endpoint.call(request.env)
        end
      end
      
      protected
      
      #
      # This method authorizes the client.
      #
      # allow_approval: false by default, but can be anything
      # that translates to true/false in Ruby (e.g. a symbol).
      #
      def authorize_endpoint(allow_approval = false)
        
        Rack::OAuth2::Server::Authorize.new do |req, res|
          @client = Oauth2Providable::Client.find_by_identifier(req.client_id) || req.bad_request!
          res.redirect_uri = @redirect_uri = req.verify_redirect_uri!(@client.redirect_uri)
          
          if allow_approval
            if params[:approve].present? && req.response_type == :code
              authorization_code = current_user.authorization_codes.create!(
                :client => @client,
                :account_sid => request.env['rack.session']['session_id'])
              res.code = authorization_code.token
              res.approve!
            else
              req.access_denied!
            end
          else
            @response_type = req.response_type
          end
          
        end
        
      end
      
    end
    
  end
  
end
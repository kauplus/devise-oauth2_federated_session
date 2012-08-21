module Devise
  module Oauth2FederatedSession
    def self.client_notifier
      Devise::Oauth2FederatedSession::ClientNotifier.instance
    end
  end
end


require 'rest-client'
require 'devise_oauth2_providable'
require 'devise/oauth2_federated_session/client_notifier'
require 'devise/oauth2_federated_session/engine'
require 'devise/oauth2_federated_session/session'


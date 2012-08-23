#
# This patch applies changes in the devise_oauth2_providable gem
# that are specific to this gem. Because these changes are
# not bug fixes or improvements of any kind to the original gem,
# making a pull request wasn't an option.
#
# Forking the project would mean not being able to specify
# devise_oauth2_providable as a dependency in the gemspec, which
# in our view wasn't a good way to go.
#

module Devise
  module Oauth2Providable
    ACCESS_TOKEN_ENV_REF = 'oauth2.access_token'
  end
end

Devise::Strategies::Oauth2Providable.class_eval do
  def authenticate!
    @req.setup!
    token = Devise::Oauth2Providable::AccessToken.find_by_token @req.access_token
    env[Devise::Oauth2Providable::ACCESS_TOKEN_ENV_REF] = token.token if token
    
    # This is the only line that was changed in this method (it was added).
    env[Devise::Oauth2Providable::CLIENT_ENV_REF] = token.client if token
    
    resource = token ? token.user : nil
    if validate(resource)
      success! resource
    else
      fail(:invalid_token)
    end
  end
end

Devise::Strategies::Oauth2GrantTypeStrategy.class_eval do
  def valid?
    env['action_controller.instance'].is_a?(Devise::Oauth2Providable::TokensController) && request.post? && params[:grant_type] == grant_type
  end
end

Devise::Oauth2Providable::AuthorizationCode.class_eval do
  attr_accessible :account_sid
end

# Client subclass
require 'devise/oauth2_federated_session/client'
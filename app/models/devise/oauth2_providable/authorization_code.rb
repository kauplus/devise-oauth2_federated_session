#
# This is a patch to the devise_oauth2_providable gem.
#
# Overrides Devise-Oauth2Providable AuthorizationCode by setting
# account_sid as an accessible attribute.
#
class Devise::Oauth2Providable::AuthorizationCode < ActiveRecord::Base
  expires_according_to :authorization_code_expires_in
  attr_accessible :account_sid
end

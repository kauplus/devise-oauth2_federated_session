class Devise::Oauth2Providable::AuthorizationCode < ActiveRecord::Base
  expires_according_to :authorization_code_expires_in
  attr_accessible :account_sid
end

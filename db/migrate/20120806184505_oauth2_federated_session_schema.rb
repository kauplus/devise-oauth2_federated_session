class Oauth2FederatedSessionSchema < ActiveRecord::Migration

  def change
    
    prefix = Devise::Oauth2Providable.table_name_prefix
    
    #
    # Access tokens
    #
    
    access_tokens_table = prefix + 'access_tokens'
    
    add_column access_tokens_table, :account_sid, :string
    add_column access_tokens_table, :session_expired_at, :datetime
    
    change_table access_tokens_table do |t|
      t.index [:account_sid, :user_id]
    end
    
    #
    # Authorization codes
    #
    
    authorization_codes_table = prefix + 'authorization_codes'
        
    add_column authorization_codes_table, :account_sid, :string
    
    #
    # Clients
    #
    
    clients_table = prefix + 'clients'
    
    add_column clients_table, :uses_account_sid, :boolean, :default => false
    add_column clients_table, :session_expired_notification_uri, :string
    
  end
  
end

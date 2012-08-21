class Devise::Oauth2FederatedSession::ClientNotifier
  include Singleton
  
  def initialize
    @enabled = Rails.application.config.devise_oauth2_federated_session.use_client_notification
    @delay   = defined?(Delayed::Job)
  end
  
  #
  # Sends a POST request to all clients that were using tokens that
  # have been expired and have notifications enabled.
  #
  def notify_expired_session(tokens)
    if @enabled
      tokens.map {|t| [t.client.session_expired_notification_uri, token: t.token]}.each do |args|
        if args.first.present?
          @delay ? RestClient.delay.post(*args) : RestClient.post(*args)
        end
      end
    end
  end
  
end
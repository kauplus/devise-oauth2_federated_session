Devise::Oauth2FederatedSession::Engine.routes.draw do
  
  match '/authorize'               => 'authorizations#new'
  match '/authorizations/create'   => 'authorizations#create', :as => :authorizations
  
  match '/sessions/create'         => 'sessions#create'
  match '/sessions/is_alive'       => 'sessions#is_alive'
  match '/sessions/recognize_user' => 'sessions#recognize_user', :as => :recognize_user
  
  devise_scope :user do 
    match '/sessions/destroy' => 'devise_sessions#destroy'
  end
  
end
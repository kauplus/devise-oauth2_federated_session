$:.push File.expand_path("../lib", __FILE__)
require "devise/oauth2_federated_session/version"

Gem::Specification.new do |s|
  
  s.name        = 'devise-oauth2_federated_session'
  s.version     = Devise::Oauth2FederatedSession::VERSION
  s.author      = 'Kauplus'
  s.email       = ['dev@kauplus.com.br']
  s.homepage    = "https://github.com/kauplus/devise-oauth2_federated_session"
  s.summary     = %q{Federated session management engine for Devise-enabled Rails applications}
  s.description = %q{Rails 3 engine built upon Devise and Devise-OAuth2Providable to add federated
                     session management functionality using OAuth2 access tokens as a sort of centralized
                     (federated) cookie.}.gsub(/\n\s+/, " ")
  
  s.rubyforge_project = 'devise-oauth2_federated_session'

  s.add_dependency('rails', '>= 3.2')
  s.add_dependency('devise', '>= 1.4.3')
  s.add_dependency('devise_oauth2_providable', '>= 1.1.2')
  s.add_dependency('rest-client', '>= 1.6.7')
  
  s.add_development_dependency('pry')
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
end
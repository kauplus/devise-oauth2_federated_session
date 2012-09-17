devise-oauth2\_federated\_session
===============================

The devise-oauth2\_federated\_session gem aims to provide federated session management functionality to a group of applications composed of one Rails OAuth2 provider and one or more trusted applications (which will be OAuth2 clients) that are not hosted in the same domain as the provider application, and therefore cannot use traditional session management solutions such as shared cookies.

It is built upon the widely used [Devise](https://github.com/plataformatec/devise) authentication gem and the [devise\_oauth2\_providable](https://github.com/socialcast/devise_oauth2_providable) gem, which is an OAuth2 module for Devise.

OAuth2 access tokens are used to emulate shared cookies between applications. A valid access token (non-expired) means there is an active browser session going on for one given client. Access tokens are linked to specific Rack session IDs and are expired when the user logs out.

**IMPORTANT:** this is a work in progress.

Requirements
------------

* Devise authentication library (<https://github.com/plataformatec/devise>)
* OAuth2 Provider module for Devise (<https://github.com/socialcast/devise_oauth2_providable>)
* Rails 3.2.x (<https://github.com/rails/rails>)

Optional features
-----------------

_(See more information on the how-to guide below)_

* Use [whenever](https://github.com/javan/whenever) to force session expiration when sessions are older than some configurable amount of time (default is 1 day);
* Use [delayed_job](https://github.com/collectiveidea/delayed_job) to notify client applications that a user's session has expired.

### Installation

This is a [Rails 3 engine](http://edgeguides.rubyonrails.org/engines.html) and it is distributed as a gem, which is how it should be used in your app.

Include the gem in your Gemfile:

    gem 'devise-oauth2_federated_session', '0.0.1'

### Setup

Setup devise. A basic setup is shown below; for more information, check [Devise's Github page](https://github.com/plataformatec/devise).

    rails generate devise:install
    rails generate devise User
    rails generate devise:views
    rake db:migrate

Install and run required migrations:

    rake devise_oauth2_providable:install:migrations
    rake devise-oauth2_federated_session:install:migrations
    rake db:migrate

### How-to guide

#### Registering a new client

    # From Rails console, or in seeds.rb
    client = Devise::Oauth2FederatedSession::Client.create(
      :name => 'My Client',
      :redirect_uri => 'http://localhost:9393/oauth/callback',
      :session_expired_notification_uri => 'http://localhost:9393/session_expired_notification',
      :website => 'http://localhost:9393/'
    )
    
#### Registering a new user

    # From Rails console, or in seeds.rb
    User.create!({:email => 'john@doe.com', :password => '111111', :password_confirmation => '111111' })

#### Configuring client notifications and delayed job

Client notifications are enabled by default, which means the provider application will always notify all client applications when a user's session expires. The notifications will be sent asynchronously if the `delayed_job` gem is available; otherwise, requests will be sent during the logout request.

##### Making sure delayed_job is available to the engine

Simply add it to your Gemfile and run the required migrations (check the author's [guide](https://github.com/collectiveidea/delayed_job) on how to do that).

##### Disabling client notifications

    # config/application.rb or the specific environment file (config/environments/*.rb)
    config.devise_oauth2_federated_session.use_client_notification = false
    
#### Using whenever to expire old sessions

`whenever` is an awesome gem that translates scheduling commands written in Ruby to unix's crontab format.
For more information, check their [Github page](https://github.com/javan/whenever).

Below is shown an example of a task that can be placed in `schedule.rb`. This task will run once per day, expiring all sessions older than `config.devise_oauth2_federated_session.expire_sessions_in` (default is 1 day).

    every 1.day, :at => '0:00 am' do
      rake 'devise_oauth2_federated_session:sessions:expire'
    end
    
Don't forget to update the crontab:

    whenever update_crontab

### Example

We recommend you check out the <a href="https://github.com/kauplus/federated-session-example">example applications repository</a>, which contains a client and a provider. 
This example was adapted from [@aganov's example](https://github.com/aganov/devise-oauth2-provider-client).

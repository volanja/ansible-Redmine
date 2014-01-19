# Settings specified here will take precedence over those in config/application.rb
require 'oauth/rack/oauth_filter'
RedmineApp::Application.configure do
  config.middleware.use OAuth::Rack::OAuthFilter
end

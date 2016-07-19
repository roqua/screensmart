ENV['APPSIGNAL_APP_ENV'] = ENV['HEROKU_APP_NAME'].gsub(/screensmart-pr-?/, '') if ENV['HEROKU_APP_NAME']
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Screensmart
  class Application < Rails::Application
    config.middleware.use 'OliveBranch::Middleware'
  end
end

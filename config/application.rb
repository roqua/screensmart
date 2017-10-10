app_name = ENV['HEROKU_APP_NAME']
if app_name&.include?('-pr-')
  ENV['APPSIGNAL_APP_ENV'] = app_name.gsub(/screensmart-pr-?/, '')
end

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Screensmart
  class Application < Rails::Application
    config.lograge.enabled = true

    if ENV["RAILS_LOG_TO_STDOUT"].present?
      config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    end

    config.middleware.use OliveBranch::Middleware

    config.i18n.available_locales = :nl
    config.i18n.default_locale = :nl

    config.time_zone = 'Amsterdam'
  end
end

require File.expand_path('../boot', __FILE__)

# Don't require Rails database stuff
%w(
  rails
  action_controller
  action_view
  active_job
  sprockets
  active_resource
).each do |railtie|
  require railtie
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Screensmart
  class Application < Rails::Application
    config.browserify_rails.commandline_options = '-t coffeeify --extension=".coffee"'
    config.browserify_rails.source_map_environments << 'development'
    config.webpack = {
      use_manifest: true,
      asset_manifest: {},
      common_manifest: {}
    }
  end
end

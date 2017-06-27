ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/collection_matchers'
require 'capybara-screenshot/rspec'
require 'capybara/poltergeist'
require 'database_cleaner'
require 'vcr'
require 'opencpu'
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include RSpec::Repeat

  config.around :example, type: :feature do |example|
    repeat example, 5.times, verbose: true
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.disable_monkey_patching!
  config.infer_spec_type_from_file_location!

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  else
    SimpleCov.start 'rails'
  end

  config.order = :random
  config.expose_dsl_globally = true

  # Add focus: true to a context to run only that test
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  save_screenshots_as_circleci_artifacts

  mock_all_calls_to_r

  Capybara.default_driver = :poltergeist
  Capybara.default_max_wait_time = 7

  # Capybara.register_driver :poltergeist do |app|
  #   options = {
  #     js_errors: false # do not reraise JS errors as Ruby errors
  #   }
  #   Capybara::Poltergeist::Driver.new(app, options)
  # end

  Rails.application.routes.default_url_options[:host] = 'test_host'

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
end

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/collection_matchers'
require 'capybara-screenshot/rspec'
require 'capybara/poltergeist'
require 'vcr'
require 'opencpu'
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.disable_monkey_patching!
  config.infer_spec_type_from_file_location!
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random
  config.expose_dsl_globally = true

  save_screenshots_as_circleci_artifacts

  mock_all_calls_to_r

  Capybara.default_driver = :poltergeist
end

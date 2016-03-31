require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/collection_matchers'
require 'capybara-screenshot/rspec'
require 'capybara/poltergeist'
require 'vcr'
require 'opencpu'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  config.infer_spec_type_from_file_location!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random

  config.expose_dsl_globally = true

  Kernel.srand config.seed

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  VCR.configure do |vcr|
    vcr.cassette_library_dir = 'spec/cassettes'
    vcr.hook_into :webmock
    vcr.configure_rspec_metadata!
    vcr.ignore_localhost = true
  end

  OpenCPU.configure do |opencpu|
    opencpu.endpoint_url = 'https://opencpu.roqua-staging.nl/ocpu'
    opencpu.username     = 'deploy'
    opencpu.password     = 'needed_for_opencpu_integration'
  end

  Capybara.default_driver = :poltergeist
end

def mock_all_calls_to_r
  ensure_endpoint_matches_cassette
  configure_vcr
  always_use_vcr
end

def ensure_endpoint_matches_cassette
  OpenCPU.configure do |opencpu|
    opencpu.endpoint_url = 'https://opencpu.roqua-staging.nl/ocpu'
    opencpu.username     = 'deploy'
    opencpu.password     = 'needed_for_opencpu_integration'
  end
end

def configure_vcr
  VCR.configure do |vcr|
    vcr.cassette_library_dir = 'spec/cassettes'
    vcr.hook_into :webmock
    vcr.configure_rspec_metadata!
    vcr.ignore_localhost = true

    vcr.default_cassette_options = {
      allow_playback_repeats: true,
      match_requests_on: [:body, :uri, :method]
    }
  end
end

def always_use_vcr
  RSpec.configure do |config|
    config.around :example do |example|
      VCR.use_cassette('screensmart') { example.run }
    end
  end
end

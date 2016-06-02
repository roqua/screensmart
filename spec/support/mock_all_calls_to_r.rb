# In case of a new screensmart-r release that has not been deployed yet, take these steps:
# 1. Run screensmart-r opencpu locally by running `docker build -t screensmart-r . && docker run -p 80:80 screensmart-r`
# 2. Delete the recordings that should be updated from spec/cassettes/screensmart.yml
# 3. opencpu.endpoint_url = https://local-opencpu-server/ocpu
# 4. vcr.default_cassette_options[:record] = :once
# 5. run the specs
# After done running specs (which records the new API results):
# 6. Change all `uri` lines in screensmart.yml from your local openCPU server to https://opencpu.roqua-staging.nl/ocpu
# 7. Limit each array element to two or three items because there's no need to have a dataset of 100 items in tests.

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

# In case of a new screensmart-r release that has not been deployed yet, take these steps:
#
# 1. Run screensmart-r opencpu locally by running
#    `docker build -t screensmart-r . && docker run -it -p 80:80 screensmart-r`
# 2. Delete the recordings that should be updated from spec/cassettes/screensmart.yml
# 3. Uncomment the call to `enable_update_mode` in `mock_all_calls_to_r`
# 4. run the specs
# After done running specs (which records the new API results):
# 5. Change all `uri` lines in screensmart.yml from your local openCPU server to https://opencpu.roqua-staging.nl/ocpu
# 6. Limit each array element to two or three items because there's no need to have a dataset of 100 items in tests.

def mock_all_calls_to_r
  ensure_endpoint_matches_cassette
  configure_vcr
  always_use_vcr

  # enable_update_mode # uncomment for development, see instructions above
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

def enable_update_mode
  OpenCPU.configure do |opencpu|
    # change url to own IP if not using docker-machine
    opencpu.endpoint_url = "http://#{`docker-machine ip default`.strip}/ocpu"
  end

  VCR.configure do |vcr|
    vcr.default_cassette_options[:record] = :new_episodes
  end
end

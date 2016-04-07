source 'https://rubygems.org'

gem 'rails', '4.2.6'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'active_model_serializers'
gem 'responders'
gem 'rack-haproxy_status', '~> 0.8.1'

gem 'sprockets-rails', '2.3.3' # http://stackoverflow.com/a/34344602/2552895

gem 'appsignal', '~> 0.11.17'

gem 'activeresource'

gem 'jquery-rails'
gem 'coffee-rails', '~> 4.1.1'
gem 'coffee-script-source', '~> 1.10.0'
gem 'haml-rails', '~> 0.9'
gem 'neat', '~> 1.7.3'
gem 'bourbon'
gem 'font-awesome-rails'
gem 'browserify-rails', '~> 3.0.1'

gem 'opencpu'

gem 'dotenv-rails'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'byebug'
  gem 'awesome_print', '~> 1.6'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'

  gem 'guard',               '~> 2.13.0'
  gem 'guard-rspec',         '~> 4.6.4'
  gem 'guard-rubocop',       '~> 1.1'
  gem 'guard-coffeelint'
  gem 'guard-bundler'
  gem 'guard-npm'
end

group :test do
  gem 'rubocop'
  gem 'coffeelint'
  gem 'rspec-rails', '~> 3.4.2'
  gem 'rspec-collection_matchers', '~> 1.1.2'
  gem 'vcr', '~> 3.0.1'
  gem 'webmock', '~> 1.24.2'

  gem 'capybara',            '~> 2.6.2'
  gem 'capybara-screenshot', '~> 1.0.11'
  gem 'poltergeist',         '~> 1.9.0'
end

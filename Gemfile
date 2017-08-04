source 'https://rubygems.org'

gem 'rails', '~> 5.0.1'

gem 'roqua-styleguide', git: 'git@gitlab.roqua.nl:roqua/styleguide.git'

# Keep at 0.9, too many breaking changes in 0.10
gem 'active_model_serializers', '~> 0.9.3'

gem 'pg', '~> 0.21.0'
gem 'rack-haproxy_status', '~> 0.8.1'
gem 'responders', '~> 2.4.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'sprockets-rails', '~> 3.2.0'

gem 'appsignal', '~> 2.2.1'

gem 'bourbon', '~> 4.3.4'
gem 'coffee-rails', '~> 4.2.2'
gem 'coffee-script-source', '~> 1.12.2'
gem 'font-awesome-rails'
gem 'haml-rails', '~> 1.0.0'
gem 'jquery-rails'
gem 'neat', '~> 1.7.3'
gem 'react-rails', '~> 1.7.1'

gem 'active_interaction', '~> 3.5'
gem 'jsonb_accessor', '0.4.0.beta'
gem 'mailgun_rails', '~> 0.9.0'
gem 'opencpu', '~> 0.10.0'
gem 'valid_email', '~> 0.0'

gem 'dotenv-rails', '~> 2.2.1'

gem 'puma', '~> 3.9'

gem 'olive_branch'
gem 'prawn'
gem 'prawn-table'

group :development, :test do
  gem 'awesome_print', '~> 1.6'
  gem 'byebug'
  gem 'therubyracer'
end

group :development do
  gem 'letter_opener'

  gem 'spring'
  gem 'web-console', '~> 2.0'

  gem 'guard', '~> 2.13.0'
  gem 'guard-bundler'
  gem 'guard-coffeelint'
  gem 'guard-livereload', '~> 2.4.0'
  gem 'guard-rspec', '~> 4.6.4'
  gem 'guard-rubocop', '~> 1.1'

  gem 'thin' # Allows usage of rails server with async requests
end

group :test do
  gem 'rspec-repeat'

  gem 'database_cleaner'
  gem 'rails-controller-testing'

  gem 'simplecov'

  gem 'coffeelint'
  gem 'fabrication', '~> 2.15.2'
  gem 'rspec-collection_matchers', '~> 1.1.2'
  gem 'rspec-rails'
  gem 'vcr', '~> 3.0.1'
  gem 'webmock', '~> 1.24.2'

  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'pdf-reader'
  gem 'poltergeist'
end

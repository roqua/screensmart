ENV['APPSIGNAL_APP_ENV'] = "Heroku #{ENV['HEROKU_APP_NAME'].gsub(/screensmart-?/, '')}" if ENV['HEROKU_APP_NAME']

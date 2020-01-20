SparkPostRails.configure do |c|
  c.api_endpoint = ENV["SPARKPOST_APIURL"]
  c.api_key = ENV["SPARKPOST_APIKEY"]
  c.html_content_only = true
end

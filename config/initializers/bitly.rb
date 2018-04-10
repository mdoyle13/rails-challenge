bitly = Bitly.new(ENV['BITLY_USERNAME'], ENV['BITLY_API_KEY'])

Bitly.use_api_version_3

Bitly.configure do |config|
  config.api_version = 3
  config.access_token = ENV['BITLY_TOKEN']
end
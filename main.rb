require 'dotenv'
require 'faraday'
require 'faraday_middleware'
require 'multi_json'

# Load in credentials
Dotenv.load
email = ENV['SUMOLOGIC_EMAIL']
password = ENV['SUMOLOGIC_PASSWORD']

# Initialize Faraday session
headers = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
session = Faraday.new(url: 'https://api.sumologic.com/api/v1', headers: headers) do |connection|
  connection.basic_auth(email, password)
  connection.request  :json
  connection.response :json, content_type: 'application/json'
  connection.adapter  Faraday.default_adapter
end

# Make the API Request
input_query = "YOUR_QUERY_HERE"
params = {q: input_query, from: '', to: '', tz: 'UTC'}
r = session.get do |req|
  req.url 'logs/search'
  req.params = params
end

# Print out the response body
puts "#{r.body}"

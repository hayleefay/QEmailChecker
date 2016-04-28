require 'date'
require 'dotenv'
require 'faraday'
require 'faraday_middleware'
require 'json'
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
puts "Making API Request..."
input_query = "EMD_87fwPXxeDQ3bZ9X"
params = {q: input_query, from: DateTime.now.prev_day, to: DateTime.now, tz: 'UTC'}
r = session.get do |req|
  req.url 'logs/search'
  req.params = params
end
puts "\tDone!"


# Grab the interesting information from each item returned
puts "Parsing response..."
r.body.each do |i|
	raw_message = JSON.parse(i["_raw"])

	fields = raw_message["fields"] unless raw_message.nil?
	log_level = fields["level"] unless fields.nil?

	unless log_level.nil?
		if log_level.downcase == "info" && fields["method"].downcase == "logbouncedemail"
			message_json = '{' + raw_message["message"].split('{')[1]
			message_json = message_json.split('}')[0] + '}'
			message_json = JSON.parse(message_json)

			puts "\n\n"
			puts message_json["Diagnostic-Code"].gsub('x-postfix; ', '')
			puts "\n\n"
		end
	end
end
puts "\tDone!"

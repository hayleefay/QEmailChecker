require 'net/http'

#Use sumologic api to get smtp logs for a distribution
require "dotenv"
Dotenv.load
email = ENV['SUMOLOGIC_EMAIL']
password = ENV['SUMOLOGIC_PASSWORD']

input_query = 'error'
input_from = ''
input_to = ''
#Build sumo logic api uri
query = input_query
from = input_from
to = input_to
sumologic_uri = "https://api.sumologic.com/api/v1/logs/search?q=#{query}&from=#{from}&to=#{to}"
uri = URI.parse(sumologic_uri)
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
request.basic_auth(email, password)
response = http.request(request)
puts response.body

#Parse JSON and summarize error data

#Send JSON response to Qualtrics

#Use sumologic api to get smtp logs for a distribution
require "dotenv"
Dotenv.load
email = ENV['SUMOLOGIC_EMAIL']
password = ENV['SUMOLOGIC_PASSWORD']
puts email
puts password
#Parse JSON and summarize error data
#Send JSON response to Qualtrics

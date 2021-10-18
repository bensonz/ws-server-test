require 'square'
include Square

personal_token = 'EAAAEBzMsaaSZghOsQmF6DqeJUsf0ukk6OotkeRTjEdjzqN-tDRnFnRudQB0HBxM';
client = Square::Client.new(
  square_version: '2021-09-15',
  access_token: personal_token,
  environment: 'sandbox',
  custom_url: 'https://connect.squareupsandbox.com',
)

puts client ? "client connected" : "invalid"

result = client.customers.list_customers

if result.success?
  puts result.data
elsif result.error?
  warn result.errors
end
puts "request finished"

puts result.data.customers[0][:company_name]

body = {}
body[:query] = {}
body[:query][:filter] = {}
body[:query][:filter][:country] = "CN"
result2 = client.customers.search_customers(body:body)

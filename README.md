# ws-server-test
A test server written in ruby

## init
this repor is initialized with
`rail new ws-server-test`
environment variables are stored at .env, 2 credentials are required for SquareSDK
```
SQUARE_APPLICATION_ID=xxx
SQUARE_APPLICATION_SECRET=xxx
```

Requirements
```
Write a backend service in Ruby that creates/gets users with Square’s API.
The service accepts only 1 route, perhaps ‘/api/users’, all others return 404.
The service accepts only 2 methods
POST (for Create)
    i. Users data predefined

Get (for fetch) filter by location
    i. Allow “$filter=’xxx’” in the query.
```

## Basic design
### Modules
#### AuthService
    authenticate users
    reads Square credentials from env, and provide it to other modules


#### HttpRequester
    as the name

 #### Users/Customers
    The user modules, stores and reterives users data
    handles the actual request as well


### DataStructure

Our data structure will be somewhat akin to Square's.
Here's the api docuent [link](https://github.com/square/square-ruby-sdk/tree/master/doc/api)

And the one we'll be using is /customers.

Create - [link](https://github.com/square/square-ruby-sdk/blob/master/doc/api/customers.md#create-customer)
```
body = {}
body[:idempotency_key] = 'idempotency_key2'
body[:given_name] = 'Amelia'
body[:family_name] = 'Earhart'
body[:company_name] = 'company_name2'
body[:nickname] = 'nickname2'
body[:email_address] = 'Amelia.Earhart@example.com'
body[:address] = {}
body[:address][:address_line_1] = '500 Electric Ave'
body[:address][:address_line_2] = 'Suite 600'
body[:address][:address_line_3] = 'address_line_38'
body[:address][:locality] = 'New York'
body[:address][:sublocality] = 'sublocality2'
body[:address][:administrative_district_level_1] = 'NY'
body[:address][:postal_code] = '10003'
body[:address][:country] = 'US'
body[:phone_number] = '1-212-555-4240'
body[:reference_id] = 'YOUR_REFERENCE_ID'
body[:note] = 'a customer'

result = customers_api.create_customer(body: body)

if result.success?
  puts result.data
elsif result.error?
  warn result.errors
end
```

Update - [link](https://github.com/square/square-ruby-sdk/blob/master/doc/api/customers.md#update-customer)
```
customer_id = 'customer_id8'
body = {}
body[:given_name] = 'given_name8'
body[:family_name] = 'family_name0'
body[:company_name] = 'company_name2'
body[:nickname] = 'nickname2'
body[:email_address] = 'New.Amelia.Earhart@example.com'
body[:phone_number] = ''
body[:note] = 'updated customer note'
body[:version] = 2

result = customers_api.update_customer(customer_id: customer_id, body: body)

if result.success?
  puts result.data
elsif result.error?
  warn result.errors
end
```

Get - [link](https://github.com/square/square-ruby-sdk/blob/master/doc/api/customers.md#list-customers)
```
cursor = 'cursor6'
limit = 172
sort_field = 'DEFAULT'
sort_order = 'DESC'

result = customers_api.list_customers(cursor: cursor, limit: limit, sort_field: sort_field, sort_order: sort_order)

if result.success?
  puts result.data
elsif result.error?
  warn result.errors
end
```


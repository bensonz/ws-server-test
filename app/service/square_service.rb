require 'square'
require 'securerandom'
include Square

# https://github.com/square/square-ruby-sdk/blob/master/doc/client.md
class SquareService
    ##
    # This class handles all requets to the square's client
    # This class is static.
    # Use as:
    #     SquareService::list_customers
    # Available methods:
    #     list_customers
    #     create_customers
    ##
    def self.initialize()
        if (@square_client != nil)
            puts 'square client is present'
            return
        end
        puts 'initializing square service'
        if (ENV['SQUARE_APPLICATION_SECRET'] == nil)
            raise 'square applciation secret is missing...'
        end
        @square_client = Square::Client.new(
            square_version: '2021-09-15',
            access_token: ENV['SQUARE_APPLICATION_SECRET'],
            environment: 'sandbox',
            custom_url: 'https://connect.squareupsandbox.com',
        )
        puts 'square client connected.'
    end

    # https://github.com/square/square-ruby-sdk/blob/master/doc/api/customers.md#list-customers
    def self.list_customers
        # This function returns only 100 customers per request
        # You can use 'cursor' in param to indicate offset.
        # The 'cursor' is the value returned from your previous list_customers call.
        initialize
        @square_client.customers.list_customers
    end

    # https://github.com/square/square-ruby-sdk/blob/master/doc/models/create-customer-request.md
    def self.create_cusotmer(params)
        initialize
        puts params
    end
end
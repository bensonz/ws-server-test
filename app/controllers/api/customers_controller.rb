require 'square'
require 'securerandom'

module Api
  include Square
  class CustomersController < ApplicationController
    protect_from_forgery with: :null_session

    #GET 
    def index
      param_filter
      puts params
      puts ENV['SQUARE_APPLICATION_SECRET']
      if (ENV['SQUARE_APPLICATION_SECRET'] == "")
        return render json: {}
      end
      client = Square::Client.new(
        access_token:ENV['SQUARE_APPLICATION_SECRET'],
        environment: 'sandbox',
        custom_url: 'https://connect.squareupsandbox.com',
      )
      result = client.customers.list_customers
      puts result.errors
      if (result.success?)
        return render json: {
          success: true,
          customers: result.data.customers
        }
      else
        return render json: {
          success: false,
          customers: []
        }
      end
    end

    def param_filter
      params.permit(:$filter)
    end 

     # PATCH 
    def update
      render json: "NotImplemented"
    end 

    # POST
    def create
      puts params
      if (params[:$filter])
        puts params[:$filter]
        puts params[:$filter].upcase
        puts params[:$filter].upcase == '"CN"'
      else
        puts "no"
      end
      render json: { "error": false }, status: 200
    end
  end
end

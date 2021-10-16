module Api
  class CustomersController < ApplicationController
    protect_from_forgery with: :null_session

    def index
      render json: { "hhhh": true }
    end

    def list
      puts "hello world"
      render json: { "error": true }, status: 200
    end

    def create
      puts "creating a new user"
      render json: { "error": false }, status: 200
    end
  end
end

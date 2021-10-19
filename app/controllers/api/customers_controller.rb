module Api
  class CustomersController < SecuredController
    ##
    # TODO: Make controller persisent?
    ##
    # TODO: Fix this? if not set, get InvalidAuthenticityToken on PATCH & POST requests
    protect_from_forgery with: false
    
    # GET 
    def index
      param_filter
      # TODO: Add pagination handle?
      result = SquareService::list_customers
      if (result.success?)
        if (params[:$filter] == nil)
          return render json: {
            success: true,
            customers: result.data.customers
          }
        else
          return render json: {
            success: true,
            customers: result.data.customers.select {|person|
              person[:address][:country] == params[:$filter]
            }
          }
        end
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
      SquareService::create_cusotmer params[:customer]
      render json: { "error": false }, status: 200
    end
  end
end

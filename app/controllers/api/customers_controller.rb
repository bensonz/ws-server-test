module Api
  class CustomersController < SecuredController
    ##
    # TODO: Make controller persisent?
    ##
    # TODO: Fix this? if not set, get InvalidAuthenticityToken on PATCH & POST requests
    protect_from_forgery with: false
    # TODO: Add middleware for caching?

    # GET 
    def index
      param_filter
      # TODO: Add pagination handle?
      result = SquareService::list_customers
      if (result.success?)
        if (params[:$filter] == nil)
          return render json: {
            :success => true,
            :customers => result.data.customers
          }
        else
          return render json: {
            :success => true,
            :customers => result.data.customers.select {|person|
              # do a ignore-case compare.
              person[:address][:country].upcase == params[:$filter].upcase
            }
          }
        end
      else
        return render json: {
          :success => false,
          :customers => []
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
      ##
      # Creates a customer in square
      ##
      if !create_param_check
        return render json: { 
          :success => false, 
          :error_message => "One or more required param is missing."
          }, status: 400
      end 
      idempotency_key = SecureRandom.uuid
      # I am not sure why the body would be in params[:customer]
      # but it is.
      result = SquareService::create_cusotmer(idempotency_key, params[:customer])

      if (result.success?)
        return render json: {
          :success => true,
          :customers => result.data.customer
        }
      else
        return render json: {
          :success => false,
          :errors => result.errors,
          :customers => []
        }
      end
    end

    def create_param_check
      if (params.has_key?(:given_name) || 
        params.has_key?(:family_name) ||
        params.has_key?(:company_name) ||
        params.has_key?(:email_address) ||
        params.has_key?(:phone_number)
      )
        return true
      else
        return false
      end
    end

    def destroy
      render json: "NotImplemented" 
    end
  end
end

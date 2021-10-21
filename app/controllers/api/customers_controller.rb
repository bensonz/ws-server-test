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
        print "Customer length: #{result.data.customers.length()} \n"
        if (params[:$filter] == nil)
          return unify_return_render(true, result.data.customers)
        else
          # do ignorecase compare.
          filter_upcase = params[:$filter].upcase
          filtered = result.data.customers.select {|person|
            (person[:address][:country].upcase == filter_upcase || 
              person[:address][:locality].upcase.include?(filter_upcase))
          }
          return unify_return_render(true, filtered)
        end
      else
        return unify_return_render(false, [])
      end
    end

    def param_filter
      params.permit(:$filter)
    end 

    # POST
    def create
      ##
      # Creates a customer in square
      ##
      begin
        create_param_check
      rescue
        return unify_return_render(false, nil, ["PARAM_MISSING"], "One or more required param is missing.", 400)
      end
      result = Customer.find_by(email: params[:email])
      if (result == nil)
        return unify_return_render(false,nil, ["INVALID_DATA"], "This customer is not within our database")
      else
        new_customer = parse_customer_into_square_obj(result)
        puts new_customer
        idempotency_key = SecureRandom.uuid
        # start the square request
        sq_result = nil
        5.times do |t|
          begin
            sq_result = SquareService::create_cusotmer(idempotency_key, new_customer)
          rescue 
            # ignore errors
          end
          if (sq_result != nil) 
            break
          end
        end
      end
      if (sq_result == nil)
        return unify_return_render(false, nil, ["REQUEST_FAILURE"], "Create customer failed")
      end
      if (sq_result.success?)
        return unify_return_render(true, [sq_result.data.customer])
      else
        return unify_return_render(false, nil, sq_result.errors, "Square returned failure")
      end
    end

    def unify_return_render(success, customers, errors=nil, error_message=nil, status_code=200)
      return render json: {
        :success => success,
        :customers => customers,
        :errors => errors,
        :error_message => error_message
      }, status: status_code
    end

    def parse_customer_into_square_obj(customer_in_db)
      new_customer = {
        :email_address => customer_in_db[:email],
        :address => {
          :address_line_1 => customer_in_db[:address_line_1],
          :address_line_2 => customer_in_db[:address_line_2],
          :country => customer_in_db[:country],
          :postal_code => customer_in_db[:postal_code],
          :locality => customer_in_db[:locality]
        },
        :phone_number => customer_in_db[:phone_number],
        :given_name => customer_in_db[:first_name],
        :family_name => customer_in_db[:last_name],
        :note => customer_in_db[:note]
      }
      return new_customer
    end

    def create_param_check
      params.require(:email)
    end

     # PATCH 
     def update
      render json: "NotImplemented"
    end 

    # DELETE
    def destroy
      render json: "NotImplemented" 
    end
  end
end

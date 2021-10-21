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
        print "Customer length: "
        puts result.data.customers.length()
        if (params[:$filter] == nil)
          return render json: {
            :success => true,
            :customers => result.data.customers
          }
        else
          # do a ignorecase compare.
          filter_upcase = params[:$filter].upcase
          return render json: {
            :success => true,
            :customers => result.data.customers.select {|person|
              (person[:address][:country].upcase == filter_upcase || 
                person[:address][:locality].upcase.include?(filter_upcase))
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
      begin
        create_param_check
      rescue
        return render json: { 
          :success => false, 
          :error_message => "One or more required param is missing."
          }, status: 400
      end
      result = Customer.find_by(email: params[:email])
      if (result == nil)
        return render json: {
          :success => false,
          :error_message => "This customer is not within our database"
        }
      else
        new_customer = parse_customer_into_square_obj(result)
        puts new_customer
        idempotency_key = SecureRandom.uuid
        counter = 0;
        while counter <= 5 do
          begin
            result = SquareService::create_cusotmer(idempotency_key, new_customer)
          rescue 
            # ignore errors
          end
          if (result != nil) 
            break
          end
          counter +=1
        end
      end
      if (result == nil)
        return render json: {
          :success => false,
          :error_message => "Cannot create customer."
        }
      end
      if (result.success?)
        return render json: {
          :success => true,
          :customers => [result.data.customer]
        }
      else
        return render json: {
          :success => false,
          :errors => result.errors,
          :customers => []
        }
      end
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

    def destroy
      render json: "NotImplemented" 
    end
  end
end

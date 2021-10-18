class SecuredController < ApplicationController
    before_action :authorize_request
  
    private
  
    def authorize_request
      AuthorizationService.new(request.headers).authenticate_request!
    rescue => detail
      render json: { error: 'Not Authenticated', detail: detail }, status: :unauthorized
    end
  end
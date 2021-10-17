class PagesController < ApplicationController
    def index
        return render json: {
            :success => true,
            :status => 404
        }
    end
end

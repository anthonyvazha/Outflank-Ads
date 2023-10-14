class NewslettersController < ApplicationController
    before_action :authenticate_user!
  
    def new
        @newsletter = Newsletter.new
    end

    def show
        if current_user&.brands
            @newsletter = current_user.brands.first.newsletters.find_by(id: params[:id])

        else
            redirect_to new_user_session_path, alert: "Please sign in."
        end
    end
  
    def create
    end
    
    private
    
    def brand_params
    
    end
  end
  
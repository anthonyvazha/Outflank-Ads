class BrandsController < ApplicationController
    before_action :authenticate_user!, except: [:new, :create]
  

  
    def new
      @brand = Brand.new
      3.times { @brand.competitors.build }
    end
  
    def create
      current_user ||= User.create!(email: "#{Time.now.to_i}@outflankedads.com")
      sign_in(current_user)
      @brand = current_user.brands.build(brand_params)
      
      if @brand.save
        AdScraperJob.perform_async('brand', @brand.id)

        @brand.competitors.each do |competitor|
          AdScraperJob.perform_async('competitor', competitor.id) 
        end

        redirect_to dashboard_index_path, notice: "Created a new account, currently retrieving data"
      else
        render :new
      end
    end
    
    private
    
    def brand_params
      params.require(:brand).permit(:context, :ad_libary_url_facebook, competitors_attributes: [:ad_libary_url_facebook])
    end
  end
  
  
  
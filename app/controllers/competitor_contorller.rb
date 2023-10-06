class CompetitorsController < ApplicationController
    before_action :set_competitor, only: [:show, :edit, :update, :destroy]
  
    def new
      @competitor = Competitor.new
    end
  
    def create
      @competitor = Competitor.new(competitor_params)
      
      if @competitor.save
        redirect_to @competitor, notice: 'Competitor was successfully created.'
      else
        render :new
      end
    end
  
    # ... other actions (like show, edit, update, destroy) ...
  
    private
  
      # Use callbacks to share common setup or constraints between actions.
      def set_competitor
        @competitor = Competitor.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def competitor_params
        params.require(:competitor).permit(:ad_library_link_1, :ad_library_link_2, :ad_library_link_3)
      end
  end
  
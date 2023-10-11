class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:logout, :scraper_status]
  # skip_before_action :verify_authenticity_token, only: [:scraper_status]

  def home
  end

  def logout
    sign_out(current_user)
    redirect_to root_path
  end

  def page
    @page_key = request.path[1..-1]
    render "pages/#{@page_key}"
  end

  # def scraper_status
  #   companies_enriched = current_user.competitors.map(&:enriched?) # => [true, true, true]
  #   ads_enriched = current_user.ads.count.positive?
  #   render json: { enriched: !enriched.include?(false) && ads_enriched }
  # end
end

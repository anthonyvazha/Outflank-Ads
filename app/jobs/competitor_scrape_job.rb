require 'watir'
class CompetitorScrapeJob
  include Sidekiq::Job
  queue_as :default
  
  def perform(competitor_id)
    Rails.logger.info "ScrapeJob started at #{Time.now}"
    competitor = Brand.find(brand_id)
    #scraper = AdScraper.new(brand, brand.ad_libary_url_facebook, max_scrolls: 1)
    #scraped_data = scraper.scrape_ads
    scraper = DataScraper.new
    scraped_data = scraper.scrape(competitor.ad_libary_url_facebook, competitor)
  end
end
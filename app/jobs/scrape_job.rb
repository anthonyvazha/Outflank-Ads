require 'watir'
class ScrapeJob
  include Sidekiq::Job
  queue_as :default
  
  def perform(brand_id)
    Rails.logger.info "ScrapeJob started at #{Time.now}"
    brand = Brand.find(brand_id)
    #scraper = AdScraper.new(brand, brand.ad_libary_url_facebook, max_scrolls: 1)
    #scraped_data = scraper.scrape_ads
    scraper = DataScraper.new
    scraped_data = scraper.scrape(brand.ad_libary_url_facebook, brand)
  end
end

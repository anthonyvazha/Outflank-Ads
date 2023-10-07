require 'watir'
class ScrapeJob
  include Sidekiq::Job
  queue_as :default
  
  def perform(brand_id)
    Rails.logger.info "ScrapeJob started at #{Time.now}"
    brand = Brand.find(brand_id)
    scraper = AdScraper.new(brand.ad_libary_url_facebook, max_scrolls: 1)
    scraped_data = scraper.scrape_ads

    scraped_data.each do |scraped_ad|
      ad_attributes = {
        headline: scraped_ad["headline"],
        body: scraped_ad["body"],
        description: scraped_ad["description"],
        cta: scraped_ad["cta"],
        launch_date: scraped_ad["launch_date"],
        external_library_id: scraped_ad["library_id"].to_s, # Ensure it's a string
        brand_id: brand_id,
        # More attributes...
      }
      
      # Save scraped data to the database
      # This assumes you have an Ad model set up in your Rails app
      Ad.create(ad_attributes)
    end
    
    Rails.logger.info "ScrapeJob finished at #{Time.now}"
    

    puts scraped_data
    Rails.logger.info "ScrapeJob finished at #{Time.now}"

    
    # Handle the scraped_data...
  end
end

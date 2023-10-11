require 'watir'
class AdScraperJob
  include Sidekiq::Job
  queue_as :default
  
  def perform(company_type, company_id)
    Rails.logger.info "ScrapeJob started at #{Time.now}"
    company = company_type.titleize.constantize.find(company_id)
    DataScraper.new(company).scrape
  
     
    # calling a job to process the data
    Rails.logger.info "ScrapeJob ended at #{Time.now}"
  end
end
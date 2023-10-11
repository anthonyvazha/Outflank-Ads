class OpenAIProcessingJob
  include Sidekiq::Job
  queue_as :default

  def perform(brand)
    Rails.logger.info "Open_ai_processing has started at #{Time.now}"
    OpenAiProcessing.new.call(brand)
    Rails.logger.info "Open_ai_processing has ended at #{Time.now}"
  end
end
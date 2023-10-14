class OpenAiProcessingJob
  include Sidekiq::Job
  queue_as :default

  def perform(user_id)
    Rails.logger.info "Open_ai_processing has started at #{Time.now}"
    user = User.find(user_id)
    brand = user.brands.first
    OpenAiProcessing.new(brand).call
    Rails.logger.info "Open_ai_processing has ended at #{Time.now}"
  end
end
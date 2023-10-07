class HardJob
  include Sidekiq::Job

  def perform(*args)
    # Do something
    puts "yeah!"
  end
end

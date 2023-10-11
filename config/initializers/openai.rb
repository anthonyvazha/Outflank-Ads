OpenAI.configure do |config|
    config.access_token = ENV.fetch("OPEN_AI_API_KEY")
end
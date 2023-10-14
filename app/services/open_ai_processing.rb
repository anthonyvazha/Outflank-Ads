
class OpenAiProcessing

  attr_accessor :brand

  def initialize(brand)
    @brand = brand
    @client = OpenAI::Client.new
  end

  def system_prompt
    "Your are world class marketer that does weekly analysis on competitor ads to see what kind of ads they are running compared to your brands ads. 
    and find ways to unquily position your brand from your competitors. You can give it me in html or rich text format. You will 
    Summarize lastest ads they realeased by lauch data, (more recent ads get priotization on what to focus on). Give no more than 2 bullet points for each competitior 
    - how they differ or similar from what kind of ads your brand is running. Summerize thier entire 
    strategy based on the ads they are running in one scentace. If you just have one 
    take away from all their ad data what would it be(ad message repeated multiple times). 
    Give 3 diffrent tests we can run to stand out compared to what all the other brands are doing. Avoid discounts, more influcer or reviw ads, 
    give more creative and unique ideas to test angles from a messaging point of view."
  end

  def summarize_prompt
     "Make it sound like weekly update(& line breaks). Poke holes in my brands belife based on ads my brand ad data and give me opposing point of view of the argument. Then give me brief summary of my competitors ads trends based on the recent lastest ads. Generate 3 unique non obvious creative ideas for how I can focus on category & posititing rather then competition."
  end

  def summarize_promt_two
    'You are writing a weekly report that informs brand owners about thier competiors and the new ads they have launched recently. Poke holes in my brands belife based on ads my brand ad data and give me opposing point of view of the argument. Generate 3 unique non obvious creative ideas for how I can focus on category & posititing. Avoid mentioning anything in this prompt like "opposing pov" or empty data.'
  end

  def procces_ads(company)
    all_ads = []
    company.ads.each do |ad|
      all_ads << {id: ad.id, headline: ad.headline, body: ad.body, description: ad.description, cta: ad.cta, launch_data: ad.launch_date} 
    end
    all_ads
  end

  # def summarize_ads(ads_json)
  #   # Implement your summarization logic here
  #   summarized_ads = ads_json[0..5]  # Example: send only the first 10 ads
  #   summarized_ads
  # end

  # def test_new_ai
  #   brand_name = brand.name
  #   # competitor_name = brand.competitors.first.name #turn this into a loop. 
  #   brand_ads_json = brand.ads.map(&:to_json)
  #   competitor_ads_json = brand.competitors.flat_map { |competitor| competitor.ads.map(&:to_json) }
  
  #   brand_ads_data = procces_ads(brand)
  #   competitior_ads_data = []
  #   brand.competitors.each do |competitor|
  #     competitior_ads_data << procces_ads(competitor)
  #   end

  #   competitior_name = []
  #   brand.competitors.each do |competitor|
  #     competitior_name << competitor.name
  #   end
   
  #   puts "Brand Ads Data:"
  #   puts brand_ads_data
  #   puts "Brand Ads Data:"
  #   puts competitior_ads_data

    
  #   summarized_competitor_ads = summarize_ads(competitor_ads_json)
  #   response = HTTParty.post(
  #     'https://openrouter.ai/api/v1/chat/completions', timeout: 1000,
  #     headers: {
  #       "HTTP-Referer": ENV["BASE_URL"], 
  #       "X-Title": '', #
  #       "Authorization": "Bearer #{ENV["OPENROUTER_API_KEY"]}"
  #     },
  #     body: {
  #       "model": 'openai/gpt-4-32k', 
  #       "messages": [
  #         { role: "system", content: summarize_prompt },
  #         { role: "user", content: "Our Brand Name is: #{brand_name} vs. Competitor(s) brand name: #{competitior_name} " },
  #         { role: "user", content: "Brand ads data: #{brand_ads_data} " },
  #         { role: "user", content: "Competitors ads data: #{competitior_ads_data}" }
  #       ]
  #     }.to_json
  #   )
  #   puts "API response"

  #   if response.code == 200
  #     puts "Success: #{response.body}"
  #   else
  #     puts "Error: #{response.code} - #{response.body}"
  #   end

  #   puts response["choices"][0]["message"]["content"]
  #   Newsletter.create(brand_id: brand.id, title: "#{brand.name} x #{competitior_name[0]} - Weekly Facebook Ads Update ", content: response["choices"][0]["message"]["content"])
  # end



  # def open_ai_test
  #   brand_name = brand.name
  #   # competitor_name = brand.competitors.first.name #turn this into a loop. 
  #   brand_ads_json = brand.ads.map(&:to_json)
  #   competitor_ads_json = brand.competitors.flat_map { |competitor| competitor.ads.map(&:to_json) }
  
  #   brand_ads_data = procces_ads(brand)
  #   competitior_ads_data = []
  #   brand.competitors.each do |competitor|
  #     competitior_ads_data << procces_ads(competitor)
  #   end

  #   competitior_names = []
  #   brand.competitors.each do |competitor|
  #     competitior_names << competitor.name
  #   end
   
  #   puts "Brand Ads Data:"
  #   puts brand_ads_data
  #   puts "Brand Ads Data:"
  #   puts competitior_ads_data

    
  #   summarized_competitor_ads = summarize_ads(competitor_ads_json)


  #   response = client.chat(
  #     parameters: {
  #         model: "gpt-3.5-turbo",
  #         messages: [
  #           { role: "system", content: summarize_prompt },
  #           { role: "user", content: "Our Brand Name is: #{brand_name} vs. Competitor(s) brand name: #{competitior_names} " },
  #           { role: "user", content: "Brand ads data: #{brand_ads_data[0..3]} " },
  #           { role: "user", content: "Competitors ads data: #{competitior_ads_data[0..3]}" }
  #         ],
  #         temperature: 0.2
  #     }
  #   )
  #   puts "API response"

  #   if response.code == 200
  #     puts "Success: #{response.body}"
  #   else
  #     puts "Error: #{response.code} - #{response.body}"
  #   end
    
  #   puts response
  #   Newsletter.create(brand_id: brand.id, title: "#{brand.name} x #{competitior_name[0]} - Weekly Facebook Ads Update ", content: response["choices"][0]["message"]["content"])
  # end

  # def competitior_names
  #   competitior_name = []
  #   brand.competitors.each do |competitor|
  #     competitior_name << competitor.name
  #   end
  #   # Create loop to add more competitiors 
  #   # competitor_names = brand.competitors[0].name + brand.competitors[1].name + brand.competitors[2].name
  #   "1. #{competitior_name[0] || nil}, 2.  #{competitior_name[1] || nil}, 3. #{competitior_name[2] || nil}"
  # end
  
  # def test
  #   brand_name = brand.name
  #   # competitor_name = brand.competitors.first.name #turn this into a loop. 
  #   brand_ads_json = brand.ads.map(&:to_json)
  #   competitor_ads_json = brand.competitors.flat_map { |competitor| competitor.ads.map(&:to_json) }
  
  #   brand_ads_data = procces_ads(brand)
  #   competitior_ads_data = []
  #   brand.competitors.each do |competitor|
  #     competitior_ads_data << procces_ads(competitor)
  #   end
   
    
  #   summarized_competitor_ads = summarize_ads(competitor_ads_json)
  
  
  # end






  # def prepare_data(brand)
  #   brand_name = brand.name
  #   competitor_name = brand.competitors.first.name
  #   brand_ads_json = brand.ads.map(&:to_json)
  #   competitor_ads_json = brand.competitors.flat_map { |competitor| competitor.ads.map(&:to_json) }
  #   { brand_name: brand_name, competitor_name: competitor_name, brand_ads_json: brand_ads_json, competitor_ads_json: competitor_ads_json }
  # end

  
  
  # def summarize_competitor_ads(data)
  #   response = client.chat(
  #     parameters: {
  #         model: "gpt-3.5-turbo",
  #         messages: [
  #           { role: "system", content: "You are a world class copywriter and marketer. Summarize the competitor ads and tell the brand how they can position themselves to improve their own ads." },
  #           { role: "user", content: "Brand: #{data[:brand_name]} Competitor: #{data[:competitor_name]} This is brand ads data #{data[:brand_ads_json]} vs the competitors ads data #{data[:competitor_ads_json]}" }
  #         ],
  #         temperature: 0.7,
  #     }
  #   )
  #   response
  # end
  
  # def test(brand)
  #   data = prepare_data(brand)
  #   summarize_competitor_ads(data)
  # end

  # def test(brand)
  #  brand_name = brand.name
  #  competitor = brand.competitors.first
  #  competitor_name = brand.competitors.first.name
  #  brand_ads_json = brand.ads.map(&:to_json)   
  #  competitor_ads_json = brand.competitors.flat_map do |competitor|
  #     competitor.ads.map(&:to_json)
  #  end

  #       response = client.chat(
  #         parameters: {
  #             model: "gpt-3.5-turbo", # Required.
  #             messages: [{ role: "system", content: "You are a world class copywriter and marketer. summerize the competitior ads and tell brand how the the can position themsleves to improve their own ads. " },
  #             { role: "user", content: "Brand: #{brand_name} Competitor: #{competitor_name}  this is brand ads data #{brand_ads_json} vs the competitiors ads data #{competitor_ads_json} "}, 
              
  #           ], # Required.
  #             temperature: 0.7,
  #         })
    
  # end
  def competitior_names_string
    competitior_name = []
    brand.competitors.each do |competitor|
      competitior_name << competitor.name
    end
    # Create loop to add more competitiors 
    # competitor_names = brand.competitors[0].name + brand.competitors[1].name + brand.competitors[2].name
    "1. #{competitior_name[0] || nil}, 2.  #{competitior_name[1] || nil}, 3. #{competitior_name[2] || nil}"
  end

  def summarize_prompt
    "Give breif summary of competitors ads, trends. Then tell us how we as a brand can set our self apart in our ads based on competiotr data."
 end

  def call
    brand_name = brand.name
    brand_ads_data = procces_ads(brand)
    competitior_ads_data = []
    brand.competitors.each do |competitor|
      competitior_ads_data << procces_ads(competitor)
    end
    puts "Brand Ads Data:"
    puts brand_ads_data[0..5]
    puts "Brand Ads Data:"
    puts competitior_ads_data[0..5]

    competitior_names = []
    brand.competitors.each do |competitor|
      competitior_names << competitor.name
    end


    response = client.chat(
        parameters: {
            model: "gpt-3.5-turbo", # Required.
            messages: [
              { role: "system", content: summarize_promt_two },
              { role: "user", content: "Our Brand Name is: #{brand_name} vs. Competitor(s) brand name: #{competitior_names_string} " },
              { role: "user", content: "Brand ads data: #{brand_ads_data[0..3]} " },
              { role: "user", content: "Competitors ads data: #{competitior_ads_data[0..3]}" }            
          ], # Required.
            temperature: 0.7,
        })
    puts response["choices"][0]["message"]["content"]
    Newsletter.create(brand_id: brand.id, title: "#{brand.name} x #{competitior_names[0]} - Weekly Facebook Ads Update ", content: response["choices"][0]["message"]["content"])
  end


  private 

  def client
    @client = OpenAI::Client.new
  end




end
  
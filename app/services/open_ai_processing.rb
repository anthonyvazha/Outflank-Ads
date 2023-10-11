
class OpenAiProcessing

  attr_accessor :brand

  def initialize

  end

  def summarize_ads(ads_json)
    # Implement your summarization logic here
    summarized_ads = ads_json[0..5]  # Example: send only the first 10 ads
    summarized_ads
  end
  
  def test(brand)
    brand_name = brand.name
    competitor_name = brand.competitors.first.name
    brand_ads_json = brand.ads.map(&:to_json)
    competitor_ads_json = brand.competitors.flat_map { |competitor| competitor.ads.map(&:to_json) }
  
    summarized_brand_ads = summarize_ads(brand_ads_json)
    summarized_competitor_ads = summarize_ads(competitor_ads_json)
  
    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            { role: "system", content: "summarize the last 20 ads from cometitiors(give dates, last released), and how they differ or similar from what you are running. Summerize thier entire strategy based on thier ads they are running of facebook. If you just have one take away from all their ad data what woudl it be(ad message repeated multiple times) lastly explain what are the best ." },
            { role: "user", content: "Our Brand Name is: #{brand_name} vs. Competitor brand name: #{competitor_name} " },
            { role: "user", content: " Brand ads data: #{summarized_brand_ads} " },
            { role: "user", content: " Competitors ads data: #{summarized_competitor_ads}" }
          ],
          temperature: 0.4,
      }
    )
  end






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
    

  def call
    response = client.chat(
        parameters: {
            model: "gpt-3.5-turbo", # Required.
            messages: [{ role: "system", content: "You are a world class copywriter" },
            { role: "user", content: "in the privioues chat what is the toms fav gold bar??"}, 
            
          ], # Required.
            temperature: 0.7,
        })
  end


  private 

  def client
    @client = OpenAI::Client.new
  end




end
  
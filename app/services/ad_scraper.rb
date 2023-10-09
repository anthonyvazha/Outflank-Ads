require 'watir'
require 'date'


class AdScraper
  attr_reader :browser, :url, :max_scrolls
  attr_accessor :brand, :browser

  
  def initialize(brand,url, max_scrolls: 1)
    @browser = Watir::Browser.new(:chrome, headless: true)
    @url = url
    @brand = brand
    @max_scrolls = max_scrolls
  end
  
  def scrape_ads
    begin
      browser.goto(url)
      all_ads = []
      current_scroll = 0
      puts "Reached before while loop"

      while current_scroll < max_scrolls
        exact_ad_class_divs = browser.divs(css: 'div[class="xh8yej3"]')
        puts exact_ad_class_divs.count
        puts exact_ad_class_divs
        binding.break
        exact_ad_class_divs.each do |div|
          ad_info = extract_ad_info(div)
          all_ads << ad_info unless ad_info.nil?
        end

        browser.scroll.to :bottom
        current_scroll += 1
        sleep 1
      end
      puts "Reached before all_ads"
      puts all_ads
      all_ads
      save_ads_database(all_ads)
    rescue Selenium::WebDriver::Error::InvalidArgumentError => e
      puts "An error occurred: #{e.message}"
      # additional logging or recovery logic
    ensure
      browser.close
    end
  end

  def extract_ad_info(div)
    
      current_ad = {}
      puts "reached current_ad"
      status = div.span(class: ['x8t9es0', 'xw23nyj', 'xo1l8bm', 'x63nzvj', 'x108nfp6', 'xq9mrsl', 'x1h4wwuj', 'xeuugli', 'x1i64zmx'])
      binding.break
    if status.present?   
        
        binding.break
        headline = div.div(class: "_8jh2").div(class: '_4ik4 _4ik5')
        description = div.div(class: "_8jh3").div(class: '_4ik4 _4ik5')
        body = div.div(class: ['_7jyr', '_a25-'])
        library_id = div.div(class: ['xeuugli', 'x2lwn1j', 'x78zum5', 'xdt5ytf']).div(class: ['x1rg5ohu', 'x67bb7w'])
        cta = div.div(class: "_8jgz _8jg_").div(class: "x8t9es0 x1fvot60 xxio538 x1heor9g xuxw1ft x6ikm8r x10wlt62 xlyipyv x1h4wwuj x1pd3egz xeuugli")
        launch_date = div.div(class: ['x1cy8zhl', 'x78zum5', 'xyamay9', 'x1pi30zi', 'x18d9i69', 'x1swvt13', 'x1n2onr6'])
        
        current_ad["headline"] = headline.exists? ? headline.text : nil
        current_ad["description"] = description.exists? ? description.text : nil
        current_ad["body"] = body.exists? ? body.text : nil
        current_ad["status"] = status.text
        current_ad['library_id'] = library_id.text.gsub("Library ID: ", "").to_i
        current_ad["cta"] = cta.exists? ? cta.text : nil
        current_ad["launch_date"] = Date.parse(launch_date.text.match(/Started running on (.+)/)[1]).iso8601
        
        # Creatives (videos and images) extraction
        creatives = []
        div.videos.each do |video|
          if video.exists?
            creatives << {ad_type: 'video', src: video.src, poster: video.poster}
          end
        end
        div.imgs.each do |img|
          if img.exists? && !img.attribute_value('referrerpolicy').nil?
            creatives << {ad_type: 'image', src: img.src}
          end
        end
        current_ad["creatives"] = creatives
        puts current_ad
        current_ad
      # additional logging or recovery logic
      end
  end

  def save_ads_database(all_ads)
    puts "reached the save_ads_database"
    all_ads.each do |scraped_ad|
      ad_attributes = {
        headline: scraped_ad["headline"],
        body: scraped_ad["body"],
        description: scraped_ad["description"],
        cta: scraped_ad["cta"],
        launch_date: scraped_ad["launch_date"],
        external_library_id: scraped_ad["library_id"].to_s, # Ensure it's a string
        brand_id: brand.id,
        source: 'Facebook'
        # Todo:  attributes...(creatives)
      }
      puts scraped_ad
      Ad.create(ad_attributes)
    end
  end
  
end





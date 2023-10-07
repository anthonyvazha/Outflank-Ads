
require 'watir'
require 'date'

class AdScraper
  attr_reader :browser, :url, :max_scrolls
  
  def initialize(url, max_scrolls: 1)
    
    @browser = Watir::Browser.new(:chrome, headless: true)
    @url = url
    @max_scrolls = max_scrolls
  end
  
  def scrape_ads
    browser.goto(url)
    all_ads = []
    current_scroll = 0

    while current_scroll < max_scrolls
      exact_ad_class_divs = browser.divs(css: 'div[class="xh8yej3"]')

      exact_ad_class_divs.each do |div|
        ad_info = extract_ad_info(div)
        all_ads << ad_info unless ad_info.nil?
      end

      browser.scroll.to :bottom
      current_scroll += 1
      sleep 1
    end
    
    all_ads
  end

  def extract_ad_info(div)
    current_ad = {}
  
    status = div.span(class: ['x8t9es0', 'xw23nyj', 'xo1l8bm', 'x63nzvj', 'x108nfp6', 'xq9mrsl', 'x1h4wwuj', 'xeuugli', 'x1i64zmx'])
    return nil unless status.exists? && status.visible?
  
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
    
    current_ad
  end
  
end

class Ad
  attr_accessor :headline, :description, :body, :status, :library_id, :cta, :launch_date, :creatives
  
  def initialize(attrs = {})
    @headline = attrs[:headline]
    @description = attrs[:description]
    @body = attrs[:body]
    @status = attrs[:status]
    @library_id = attrs[:library_id]
    @cta = attrs[:cta]
    @launch_date = attrs[:launch_date]
    @creatives = attrs[:creatives]
  end
  
  def to_s
    "Headline: #{@headline}, Description: #{@description}, Body: #{@body}, Status: #{@status}, Library ID: #{@library_id}, CTA: #{@cta}, Launch Date: #{@launch_date}, Creatives: #{@creatives}"
  end
end

# # Example usage:

# # URL and Max Scrolls Configuration
# url = "https://www.facebook.com/ads/library/?active_status=all&ad_type=all&country=US&view_all_page_id=162352551085006&search_type=page&media_type=all"

# # Instance of AdScraper
# scraper = AdScraper.new(url, max_scrolls: 1)

# # Scrape Ads
# scraped_ads = scraper.scrape_ads

# # Create Ad instances and print them
# scraped_ads.each do |ad_info|
#   ad = Ad.new(ad_info)
#   puts ad
# end

class DataScraper
    attr_accessor :brand, :browser

    def initialize 
  
    end

    def name_of_brand(url)
        browser = Watir::Browser.new(:chrome, headless: true)
        #url = "https://www.facebook.com/ads/library/?active_status=all&ad_type=all&country=US&view_all_page_id=162352551085006&sort_data[direction]=desc&sort_data[mode]=relevancy_monthly_grouped&search_type=page&media_type=all"
        browser.goto(url)
        sleep(5)
        name_classes = 'x8t9es0 x1ldc4aq x1xlr1w8 x1cgboj8 x4hq6eo xq9mrsl x1yc453h x1h4wwuj xeuugli'
        name = browser.div(class: name_classes).text 
        name
    end
  
    def scrape(url, brand)
        browser = Watir::Browser.new(:chrome, headless: true)
        browser.goto(url)
        
        all_ads = []
        max_scrolls = 1
        current_scroll = 0

    

        while current_scroll < max_scrolls
            # sleep(3) # give facebook time to load the ads async in the container below the fold
            browser.wait_until { browser.divs(css: 'div[class="xh8yej3"]').count >= 10 } # && browser.divs(css: 'div[class="xh8yej3"]').count.positive?
            exact_ad_class_divs = browser.divs(css: 'div[class="xh8yej3"]')
            
            name_classes = 'x8t9es0 x1ldc4aq x1xlr1w8 x1cgboj8 x4hq6eo xq9mrsl x1yc453h x1h4wwuj xeuugli'
            brand_name = browser.div(class: name_classes).text
            brand.update(name: brand_name) 

            exact_ad_class_divs.each do |div|
                current_ad = {}
                library_id = div.div(class: ['xeuugli', 'x2lwn1j', 'x78zum5', 'xdt5ytf']).div(class: ['x1rg5ohu', 'x67bb7w'])
                status = div.span(class: ['x8t9es0', 'xw23nyj', 'xo1l8bm', 'x63nzvj', 'x108nfp6', 'xq9mrsl', 'x1h4wwuj', 'xeuugli', 'x1i64zmx'])
                if status.exists? && library_id.exists? 
                    headline = div.div(class: "_8jh2").div(class: '_4ik4 _4ik5')
                    description = div.div(class: "_8jh3").div(class: '_4ik4 _4ik5')
                    body = div.div(class: ['_7jyr', '_a25-'])
                    cta = div.div(class: "_8jgz _8jg_").div(class: "x8t9es0 x1fvot60 xxio538 x1heor9g xuxw1ft x6ikm8r x10wlt62 xlyipyv x1h4wwuj x1pd3egz xeuugli")
                    launch_date = div.div(class: ['x1cy8zhl', 'x78zum5', 'xyamay9', 'x1pi30zi', 'x18d9i69', 'x1swvt13', 'x1n2onr6'])
                    
                    current_ad["headline"] = headline.exists? ? headline.text : nil
                    current_ad["description"] = description.exists? ? description.text : nil
                    current_ad["body"] = body.exists? ? body.text : nil
                    current_ad["status"] = status.text
                    current_ad['library_id'] = library_id.text.gsub("Library ID: ", "").to_i
                    current_ad["cta"] = cta.exists? ? cta.text : nil
                    current_ad["launch_date"] = Date.parse(launch_date.text.match(/Started running on (.+)/)[1]).iso8601
                end
                # Extract video information
                div.videos.each do |video|
                    if video.exists?
                    puts "Video SRC: #{video.src}"
                    puts "Poster: #{video.poster}"
                    current_ad["creatives"] = {ad_type:'video',src:  video.src, poster: video.poster}
                    end
                end 
                # Extract image information
                div.imgs.each do |img|
                    if img.exists? && !img.attribute_value('referrerpolicy').nil?
                    puts "Creative: #{img.src}"
                    current_ad["creatives"] = {ad_type:'image' , src: img.src }
                    end
                end
                
                all_ads << current_ad
            end
            
            # Scroll down
            browser.scroll.to :bottom
            # Increment scroll count
            current_scroll += 1
            # Pause to allow content to load
            sleep 1
        end

        
        
        puts all_ads
        # clean ads using library id - 
        cleaned_ads = all_ads.select { |ad| ad.any? && ad["library_id"] }
        # Output
        browser.close
        save_ads_database(cleaned_ads, brand)
        cleaned_ads
    end

    def save_ads_database(all_ads, brand)
        puts "reached the save_ads_database"
       
        # all_ads.each do |scraped_ad|
        #   ad_attributes = {
        #     headline: scraped_ad["headline"],
        #     body: scraped_ad["body"],
        #     description: scraped_ad["description"],
        #     cta: scraped_ad["cta"],
        #     launch_date: scraped_ad["launch_date"],
        #     external_library_id: scraped_ad["library_id"].to_s, # Ensure it's a string
        #     brand_id: brand.id,
        #     source: 'Facebook'
        #     # Todo:  attributes...(creatives)
        #   }
        #   puts scraped_ad
        #   Ad.create(ad_attributes)
        # end

        if brand.brand_id.present?
            all_ads.each do |scraped_ad|
                ad_attributes = {
                  headline: scraped_ad["headline"],
                  body: scraped_ad["body"],
                  description: scraped_ad["description"],
                  cta: scraped_ad["cta"],
                  launch_date: scraped_ad["launch_date"],
                  external_library_id: scraped_ad["library_id"].to_s, 
                  source: 'Facebook',
                  competitor_id: brand.id
                  # Todo:  attributes...(creatives)
                }
                puts scraped_ad
                Ad.create(ad_attributes)
              end
            
        else
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
  
    def test
        url = "https://www.facebook.com/ads/library/?active_status=all&ad_type=all&country=US&view_all_page_id=162352551085006&sort_data[direction]=desc&sort_data[mode]=relevancy_monthly_grouped&search_type=page&media_type=all"
        scrape(url)
    end
  
  end
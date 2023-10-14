class DataScraper
    attr_accessor :company, :user, :browser

    def initialize(company)
        @company = company
        @user = @company.user
        @browser = new_browser
    end
  
    def scrape
        # browser = Watir::Browser.new(:chrome, headless: true)
        browser.goto(company.ad_libary_url_facebook)
        
        all_ads = []
        max_scrolls = 1
        current_scroll = 0

        while current_scroll < max_scrolls
            # sleep(3) # give facebook time to load the ads async in the container below the fold
            browser.wait_until { browser.divs(css: 'div[class="xh8yej3"]').count >= 10 } # && browser.divs(css: 'div[class="xh8yej3"]').count.positive?
            exact_ad_class_divs = browser.divs(css: 'div[class="xh8yej3"]')
            
            name_classes = 'x8t9es0 x1ldc4aq x1xlr1w8 x1cgboj8 x4hq6eo xq9mrsl x1yc453h x1h4wwuj xeuugli'
            company_name = browser.div(class: name_classes).text.gsub("\n", "")
            company.update(name: company_name) 

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
                    
                    current_ad["headline"] = headline.exists? ? headline.text.gsub("\n", "") : nil
                    current_ad["description"] = description.exists? ? description.text.gsub("\n", "") : nil
                    current_ad["body"] = body.exists? ? body.text.gsub("\n", "") : nil
                    current_ad["status"] = status.text
                    current_ad['library_id'] = library_id.text.gsub("Library ID: ", "").to_i
                    current_ad["cta"] = cta.exists? ? cta.text.gsub("\n", "") : nil
                    current_ad["launch_date"] = Date.parse(launch_date.text.match(/Started running on (.+)/)[1]).iso8601
                end
                # Extract video information
                div.videos.each do |video|
                    if video.exists?
                    current_ad["creatives"] = {ad_type:'video',src:  video.src, poster: video.poster}
                    end
                end 
                # Extract image information
                div.imgs.each do |img|
                    if img.exists? && !img.attribute_value('referrerpolicy').nil?
                    
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
        
        # clean ads using library id - 
        cleaned_ads = all_ads.select { |ad| ad.any? && ad["library_id"] }
        # Output
        browser.close
        save_ads_database(cleaned_ads)
        puts 'reached OpenAI Processing Job in Ad Scraper'
        
        if user.ready_for_ai?
            puts 'Inside the if statment'
            OpenAiProcessingJob.perform_sync(user.id)
        end
        cleaned_ads
    end

    private

    def save_ads_database(all_ads)
        

        all_ads.each do |scraped_ad|
            ad_attributes = {
              headline: scraped_ad["headline"],
              body: scraped_ad["body"],
              description: scraped_ad["description"],
              cta: scraped_ad["cta"],
              launch_date: scraped_ad["launch_date"],
              external_library_id: scraped_ad["library_id"].to_s, 
              source: 'Facebook',
              data:scraped_ad["creatives"] ,
              # Todo:  attributes...(creatives)
            }
        
            
            Ad.create(ad_attributes.merge("#{@company.company_type}_id" => @company.id))
          end
    end

    def new_browser
        Watir::Browser.new(:chrome, headless: true)
    end
  end
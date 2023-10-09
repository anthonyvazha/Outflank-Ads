class FbAdDataScraper 

  def initialize 

  end

  def call(brand)
    url = brand.ad_libary_url_facebook
    uri = URI.parse(url)
    params = CGI.parse(uri.query)
    page_identifier = params['view_all_page_id'].first
    send_request_for_page_identifier(page_identifier, forward_cursor=nil)
  end

  def send_request_for_page_identifier(page_identifier, forward_cursor=nil)

    puts "processing results for #{forward_cursor}"

    session_id="e81f0d2c-93c9-4f3b-951e-9be2da5f18c1"
    count = "30"
    active_status = "all"
    ad_type = "all"
    view_all_page_id = page_identifier
    media_type = "all"
    search_type = "page"

    url = "https://www.facebook.com/ads/library/async/search_ads/?session_id=#{session_id}&count=#{count}&active_status=#{active_status}&ad_type=#{ad_type}&countries%5B0%5D=ALL&view_all_page_id=#{page_identifier}&media_type=#{media_type}&search_type=#{search_type}"

    if forward_cursor.present? 
      url += "&forward_cursor=#{forward_cursor}"
    end

    headers = {
      'authority' => 'www.facebook.com',
      'accept' => '*/*',
      'accept-language' => 'en-US,en;q=0.9',
      'content-type' => 'application/x-www-form-urlencoded',
      'cookie' => 'datr=KuEiZVjo9H2_Ir2pnhT6OUVw; wd=1619x533',
      'origin' => 'https://www.facebook.com',
      'referer' => 'https://www.facebook.com/ads/library/?active_status=all&ad_type=all&country=ALL&view_all_page_id=1453931951522402&search_type=page&media_type=all',
      'sec-ch-ua' => '"Google Chrome";v="117", "Not;A=Brand";v="8", "Chromium";v="117"',
      'sec-ch-ua-mobile' => '?0',
      'sec-ch-ua-platform' => '"macOS"',
      'sec-fetch-dest' => 'empty',
      'sec-fetch-mode' => 'cors',
      'sec-fetch-site' => 'same-origin',
      'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36',
      'x-asbd-id' => '129477',
      'x-fb-lsd' => 'AVqDb0JTLGw'
    }

    data = {
      '__user' => '0',
      '__a' => '1',
      '__req' => '2',
      '__hs' => '19638.BP%3ADEFAULT.2.0..0.0',
      'dpr' => '1',
      '__ccg' => 'UNKNOWN',
      '__rev' => '1009115252',
      '__s' => 'hnzrfb%3Aw51s0l%3Aletw48',
      '__hsi' => '7287651056604212644',
      '__dyn' => '7xeUmxa3-Q8zo5ObwKBWobVo9E4a2i5U4e1FxebzEdF8ixy7EiwvoWdwJwCwfW7oqx60Vo1upEK12wvk1bwbG78b87C2m3K2y11xmfz81s8hwGwQwoE2LwBgao884y0Mo6i588Egze2a5E5afK1LwPxe3C0D8sDwJwKwHxaaws8nwhE2Lxiaw4JwJwSyES0gq0K-1LwqobU5G361pwr86C',
      '__csr' => '',
      'lsd' => 'AVqDb0JTLGw'
    }

    puts "here"

    puts data 

    response = HTTParty.post(url, headers: headers, body: data, verify:false)

    data = JSON.parse(response.body.gsub('for (;;);',''))
    
    results = data["payload"]["results"]
    debugger
    snapshot = results[0][0]['snapshot']

    # Now that we have the results, lets save them to the db

    forward_cursor = data["payload"]["forwardCursor"]

    puts "results: #{results}"
    extract_data(results)

    puts forward_cursor
    if forward_cursor.present?
      send_request_for_page_identifier(page_identifier,forward_cursor)
    end
  end
  def extract_data(results)


  end

  def test 
    send_request_for_page_identifier("1453931951522402")
  end

end
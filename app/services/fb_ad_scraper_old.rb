class FbAdScraper 

  def initialize 

  end

  def send_request_for_page_identifier(page_identifier,forward_cursor=nil)

    session_id = "5189a6b5-a99f-4008-87f8-ca40c908a879"

    parameters = {
      session_id: session_id,
      count:"30",
      active_status:"all",
      ad_type:"all",
      view_all_page_id:page_identifier,
      media_type:"all",
      search_type:"page"
    }

    if forward_cursor.present?
      parameters = parameters.merge(forward_cursor:forward_cursor)
    end

    query_string = parameters.to_query

    url = "https://www.facebook.com/ads/library/async/search_ads/?#{query_string}" 

    puts url

    # data = {
    #   '__user' => '0',
    #   '__a' => '1',
    #   '__req' => '2',
    #   '__hs' => '19638.BP%3ADEFAULT.2.0..0.0',
    #   'dpr' => '1',
    #   '__ccg' => 'UNKNOWN',
    #   '__rev' => '1009115252',
    #   '__s' => 'hnzrfb%3Aw51s0l%3Aletw48',
    #   '__hsi' => '7287651056604212644',
    #   '__dyn' => '7xeUmxa3-Q8zo5ObwKBWobVo9E4a2i5U4e1FxebzEdF8ixy7EiwvoWdwJwCwfW7oqx60Vo1upEK12wvk1bwbG78b87C2m3K2y11xmfz81s8hwGwQwoE2LwBgao884y0Mo6i588Egze2a5E5afK1LwPxe3C0D8sDwJwKwHxaaws8nwhE2Lxiaw4JwJwSyES0gq0K-1LwqobU5G361pwr86C',
    #   '__csr' => '',
    #   'lsd' => 'AVqDb0JTLGw'
    # }


    data = {
      '__user' => '0',
      '__a' => '1',
      '__req' => '2',
      '__hs' => '19638.BP%3ADEFAULT.2.0..0.0',
      'dpr' => '1.5',
      '__ccg' => 'EXCELLENT',
      '__rev' => '1009116260',
      '__s' => 'gzs80r%3Ah8az3m%3Aljpmdy',
      '__hsi' => '7287694556232539966',
      '__dyn' => '7xeUmxa3-Q8zo5ObwKBWobVo9E4a2i5U4e1FxebzEdF8ixy7EiwvoWdwJwCwfW7oqx60Vo1upEK12wvk1bwbG78b87C2m3K2y11xmfz81s8hwGwQwoE2LwBgao884y0Mo6i588Egze2a5E5afK1LwPxe3C0D8sDwJwKwHxaaws8nwhE2Lxiaw4JwJwSyES0gq0K-1LwqobU5G361pwr86C',
      '__csr' => '',
      'lsd' => 'AVoYOeasfAs',
      'jazoest' => '21025',
      '__spin_r' => '1009116260',
      '__spin_b' => 'trunk',
      '__spin_t' => '1696798614',
      '__jssesw' => '1'
    }

    puts "here"

    response = HTTParty.post(url, headers: {}, body: data, verify:false)

    #TODO: amend this to do the correct cleaning
    #data = JSON.parse(response.body)

    data = JSON.parse(response.body.gsub('for (;;);',''))
    debugger
    results = data["payload"]["results"]

    # Process results - add to database

    # Now that this page of results are processed, lets get the next page

    # Get the cursor for the next page
    forward_cursor = response["payload"]["forwardCursor"]

    if forward_cursor.present?
      send_request_for_page_identifier(page_identifier,forward_cursor)
    end

  end



  def test 
    return send_request_for_page_identifier("1453931951522402")
  end

end
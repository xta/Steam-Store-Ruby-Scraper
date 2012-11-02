require 'open-uri'
require 'nokogiri'

  site = "http://store.steampowered.com/search#sort_by=&sort_order=ASC&page="
  current_page = 1

  prepend = "search_"
  columns = %w{ price
                type
                metascore
                released
                capsule
                name
              } # capture Genre ?

  def page_doc(url, page_elements) 
    Nokogiri::HTML(open(url))/page_elements
  end

# get last search page number
  index_body_text = page_doc("#{site + current_page.to_s}",".search_pagination_right").inner_text
  last_search_page_number = index_body_text.match(/\d{3}/).to_s

# scrape each search page
  for i in 1..1 #last_search_page_number.to_i
    
    page_doc("#{site + i.to_s}",".search_result_row.odd").each do |game|
      puts price = (game/".col.search_price").text.split('$').last
      puts type = (game/".col.search_type > img").map { |image| image['src'] }.first
      puts metascore = (game/".col.search_metascore").text
      puts released = (game/".col.search_released").text
      puts capsule = (game/".col.search_capsule > img").map { |image| image['src'] }.first
      puts name = (game/".col.search_name > h4").text.inspect
    end    

    page_doc("#{site + i.to_s}",".search_result_row.even").each do |game|
      puts price = (game/".col.search_price").text.split('$').last
      puts type = (game/".col.search_type > img").map { |image| image['src'] }.first
      puts metascore = (game/".col.search_metascore").text
      puts released = (game/".col.search_released").text
      puts capsule = (game/".col.search_capsule > img").map { |image| image['src'] }.first
      puts name = (game/".col.search_name > h4").text.inspect
    end

  end


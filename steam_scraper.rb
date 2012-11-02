require 'open-uri'
require 'nokogiri'

  @@site = "http://store.steampowered.com/search#sort_by=&sort_order=ASC&page="

  class GameListing
    @@all = []
    @@columns = %w{ price
                    type
                    metascore
                    released
                    capsule
                    name
                  }

    @@columns.each do |a|
      attr_accessor a.to_sym
    end

    def self.all
      @@all
    end

    def initialize(*args)
      @@columns.each_with_index do |a,i|
        self.send("#{a}=", args[i])
      end
      @@all << self
    end
  end



  def page_doc(url, page_elements) 
    Nokogiri::HTML(open(url))/page_elements
  end

  def scrape_page(cycle_tracker,i)

    page_doc("#{@@site + i.to_s}",".search_result_row.#{cycle_tracker}").each do |game|
      price = (game/".col.search_price").text.split('$').last
      type = (game/".col.search_type > img").map { |image| image['src'] }.first
      metascore = (game/".col.search_metascore").text
      released = (game/".col.search_released").text
      capsule = (game/".col.search_capsule > img").map { |image| image['src'] }.first
      name = (game/".col.search_name > h4").text.inspect

      GameListing.new(price, type, metascore, released, capsule, name)
    end
  end

# get last search page number
  index_body_text = page_doc("#{@@site}1",".search_pagination_right").inner_text
  last_search_page_number = index_body_text.match(/\d{3}/).to_s

# scrape each search page
  for i in 1..1 #last_search_page_number.to_i => this part commented out to prevent excessive test scraping
    scrape_page("odd",i)
    scrape_page("even",i)
  end

# demo of results (only includes page #1)
  puts "There are #{last_search_page_number} search result pages. Here are results from page #1:"

  GameListing.all.each do |game|
    puts "#{game.name} was released on #{game.released} and is currently #{game.price}."
  end
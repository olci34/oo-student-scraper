require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    student_data = doc.css("div.student-card")
    array = student_data.each_with_object(Array.new) do |data,array|
      name = data.children.children[3].children[1].children.text
      location = data.children.children[3].children[3].children.text
      link = data.children[1].attributes["href"].value
      array << {name: name, location: location, profile_url: link}
    end
  end

  def self.scrape_profile_page(profile_url)
    hash = {}
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    links = doc.css("div.social-icon-container a").collect {|link| link["href"]}
    profile_quote = doc.css("div.profile-quote").text
    bio = doc.css(".description-holder p").text
    links.each do |link|
      if link.include?("twitter.com")
        hash[:twitter] = link
      elsif link.include?("linkedin.com")
        hash[:linkedin] = link
      elsif link.include?("github.com")
        hash[:github] = link
      else
        hash[:blog] = link
      end
    end
    hash[:profile_quote] = profile_quote
    hash[:bio] = bio
    hash
  end

end

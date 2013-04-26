#!/usr/bin/env ruby-2.0.0-p0
## encoding: utf-8

($LOAD_PATH << File.expand_path("..", __FILE__)).uniq!

require 'rubygems' unless defined? Gem
require "bundle/bundler/setup"
require "alfred"
require 'open-uri'
require 'nokogiri'

def generate_feedback(alfred, query)

  feedback = alfred.feedback
  query = query.gsub(/\s/, '+')
  url = "http://www.zone-telechargement.com/?do=search&subaction=search&story=#{query}"
  
  doc = Nokogiri::HTML(open(url))

  doc.css(".maincont").each do |result|
    if (result.css(".down a").length > 0) 
      link = result.css(".down a").first
      title = result.css(".titrearticles").first.text
      feedback.add_item({
        :uid      => link['href'],
        :title    => title, 
        :subtitle => title, 
        :arg      => link['href']
      })
    end
  end
  puts feedback.to_xml

end

if __FILE__ == $PROGRAM_NAME

  Alfred.with_friendly_error do |alfred|
    alfred.with_rescue_feedback = true
    query = ARGV.join(" ").strip
    generate_feedback(alfred, query)
  end
end

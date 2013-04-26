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
  url = "http://kat.ph/usearch/#{query}/?field=seeders&sorder=desc"
  url = URI::encode(url)

  doc = Nokogiri::HTML(open(url))

  doc.css(".odd").each do |result|
    if (result.css(".torrentname a.plain").length > 0) 
      link = result.css("a.idownload")[1]
      title = result.css(".torrentname a.plain").first.text
      size = result.css(".nobr.center").first.text
      seed = result.css(".green.center").first.text
      leech = result.css(".red.center").first.text
      feedback.add_item({
        :uid      => link['href'],
        :title    => title, 
        :subtitle => "#{size} - #{seed} seed - #{leech} leech",
        :arg      => "http:" + link['href']
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

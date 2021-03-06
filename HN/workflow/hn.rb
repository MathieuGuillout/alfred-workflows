#!/usr/bin/env ruby
## encoding: utf-8

($LOAD_PATH << File.expand_path("..", __FILE__)).uniq!

require 'rubygems' unless defined? Gem
require "bundle/bundler/setup"
require "alfred"
require 'open-uri'
require 'hpricot'

def generate_feedback(alfred, query)

  feedback = alfred.feedback

    
  doc = Hpricot(open('https://news.ycombinator.com/'))

  doc.search("td.title a").each do |link|
    feedback.add_item({
      :uid      => link['href'],
      :title    => link.innerHTML,
      :subtitle => link['href'],
      :arg      => link['href'] 
    })
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

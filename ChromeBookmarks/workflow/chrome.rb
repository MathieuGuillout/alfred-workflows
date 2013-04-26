#!/usr/bin/env ruby
## encoding: utf-8

($LOAD_PATH << File.expand_path("..", __FILE__)).uniq!

require 'rubygems' unless defined? Gem
require "bundle/bundler/setup"
require "alfred"
require "json"

def generate_feedback(alfred, query)

  feedback = alfred.feedback

  bookmarks_file = "/Users/mattam/Library/Application Support/Google/Chrome/Default/Bookmarks"

  bookmarks = JSON.parse(File.read(bookmarks_file))
  bookmarks = bookmarks["roots"]["bookmark_bar"]["children"]

  found = bookmarks.select {|bookmark|
    bookmark['name'].match /#{query}/i
  }
  
  found.each do |elt|
    feedback.add_item({
      :uid      => "Bookmark Default Search #{elt['id']}",
      :title    => "#{elt['name']}",
      :subtitle => "#{elt['url']}",
      :arg      => elt["url"] 
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

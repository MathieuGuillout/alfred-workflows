#!/usr/bin/env ruby
## encoding: utf-8

($LOAD_PATH << File.expand_path("..", __FILE__)).uniq!

require 'rubygems' unless defined? Gem
require "bundle/bundler/setup"
require "alfred"
require "json"

def distance a, b
  query = /#{(a.downcase.split //).join(".*")}/

  if (match = b.downcase.match(query)) then
    100 / ((match.begin(0) + 1) * (match.end(0) - match.begin(0)))
  else
    0
  end
end

def generate_feedback(alfred, query)

  feedback = alfred.feedback

  bookmarks_file = "/Users/mattam/Library/Application Support/Google/Chrome/Default/Bookmarks"

  bookmarks = JSON.parse(File.read(bookmarks_file))
  bookmarks = bookmarks["roots"]["bookmark_bar"]["children"]

  found = bookmarks.map {|bookmark|
    { :bookmark => bookmark, :d => distance(query, bookmark['name'])  }
  }.select { |a| 
    a[:d] > 0 
  }.sort { |a, b| 
    b[:d] <=> a[:d]
  }
  
  found.each do |elt|
    feedback.add_item({
      :uid      => "Bookmark Default Search #{elt[:bookmark]['id']}",
      :title    => "#{elt[:bookmark]['name']}",
      :subtitle => "#{elt[:d]} - #{elt[:bookmark]['url']}",
      :arg      => elt[:bookmark]["url"] 
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

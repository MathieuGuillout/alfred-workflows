require 'rbconfig'
dest_path = "/Users/mattam/Documents/protos/AlfredKat/workflow/bundle/ruby/1.8/gems/nokogiri-1.5.9/lib"
RbConfig::MAKEFILE_CONFIG['sitearchdir'] = dest_path
RbConfig::CONFIG['sitearchdir'] = dest_path
RbConfig::MAKEFILE_CONFIG['sitelibdir'] = dest_path
RbConfig::CONFIG['sitelibdir'] = dest_path

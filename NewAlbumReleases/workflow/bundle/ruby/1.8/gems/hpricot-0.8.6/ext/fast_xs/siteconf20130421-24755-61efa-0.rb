require 'rbconfig'
dest_path = "/Users/mattam/Documents/protos/AlfredHN/workflow/bundle/ruby/1.8/gems/hpricot-0.8.6/lib"
RbConfig::MAKEFILE_CONFIG['sitearchdir'] = dest_path
RbConfig::CONFIG['sitearchdir'] = dest_path
RbConfig::MAKEFILE_CONFIG['sitelibdir'] = dest_path
RbConfig::CONFIG['sitelibdir'] = dest_path

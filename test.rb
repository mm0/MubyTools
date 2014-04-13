#!/usr/bin/ruby
#

#require_relative 'modules/unix'
#puts Unix.installed?

require_relative 'modules/commands/gunzip'
puts Gunzip.new
puts Gunzip.new.sub_category
puts Gunzip_compress.new.title
puts Gunzip_decompress.new.title

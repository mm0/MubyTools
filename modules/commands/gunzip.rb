#!/usr/bin/ruby
#
	require_relative '../unix'
	require_relative '../command'

class Gunzip 
include Unix
include Command

	def initialize
		init
		@sub_category = "Gunzip"
	end 

	def can_use?
		return installed?  
	end
	def installed? 
		super
		@@binary = `which gunzip`
	end
end


class Gunzip_compress < Gunzip
	def initialize
		super
		@title = "Compress File(s)"
		@description = "Compresses a selection of one or more files into output of choice"
		@shortcut = "gunzip_c"
		@sort = 100
	end
end

class Gunzip_decompress < Gunzip
	def initialize
		super
		@title = "Uncompress Gunzip File"
		@description = "Decompresses a selected zip file "
		@shortcut = "gunzip_d"
		@sort = 200
	end
end

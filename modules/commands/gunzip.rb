#!/usr/bin/ruby
#
	require_relative '../unix'
	require_relative '../command'

class Gunzip 
include Unix
include Command
	

	def initialize
		init
		@sort 			=	0
		@ENABLED		=	false
		@title			=	"GUNZIP File"
		@shortcut		=	"gunzip"
		@description	=	"GUNZIP File"
		@category		=	"Local CLI Commands"
		@sub_category 	=	"Commands to be executed locally through a Shell"
		@command_type	=	"UNIX"
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
		@title 			= "Compress File(s)"
		@ENABLED		=	true
		@description 	= "Compresses a selection of one or more files into output of choice"
		@shortcut 		= "gunzip_c"
		@sort 			= 100
	end
end

class Gunzip_decompress < Gunzip
	def initialize
		super
		@title 			= "Uncompress Gunzip File"
		@ENABLED		=	true
		@description 	= "Decompresses a selected zip file "
		@shortcut 		= "gunzip_d"
		@sort 			= 200
	end
end

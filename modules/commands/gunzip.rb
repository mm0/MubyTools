#!/usr/bin/ruby
#
	require_relative '../unix'
	require_relative '../command'

class Gzip 
include Unix
include Command
	

	def initialize
		init
		@ENABLED		=	false
		@sort 			=	0
		@title			=	"GZIP File"
		@shortcut		=	"gzip"
		@description	=	"GZIP File"
		@category		=	"Local CLI Commands"
		@sub_category 	=	"Commands to be executed locally through a Shell"
		@command_type	=	Current_User
	end 

	def can_use?
		return installed?  
	end
	def installed? 
		super
		@@binary = `which gunzip`
		return @@binary
	end
end


class Gunzip_compress < Gzip
	def initialize
		super
		init
		@title 			= "Compress File(s)"
		@command		=	"gzip -9 {filename}"
		@description 	= "Compresses a selection of one or more files into output of choice"
		@shortcut 		= "gunzip_c"
		@sort 			= 100
	end
	def installed? 
		super
		@@binary = `which gzip`
		return @@binary
	end
    def get_input_array
        file_input       = TTY_input.new
        file_input.required = true
        file_input.name  =   "Filename"
        file_input.string=   "filename"
        return [file_input]
    end 
end

class Gunzip_decompress < Gzip
	def initialize
		super
		init
		@title 			= "Uncompress Gunzip File"
		@command		=	"gunzip {filename}"
		@description 	= "Decompresses a selected zip file "
		@shortcut 		= "gunzip_d"
		@sort 			= 200
	end
    def get_input_array
        file_input       = TTY_input.new
        file_input.required = true
        file_input.name  =   "Filename"
        file_input.string=   "filename"
        return [file_input]
    end 
end

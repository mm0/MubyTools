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
		@command_type	=	Current_User
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
		@command		=	"gzip -9 {filename}"
		@description 	= "Compresses a selection of one or more files into output of choice"
		@shortcut 		= "gunzip_c"
		@sort 			= 100
	end
    def get_input_array
        file_input       = TTY_input.new
        file_input.required = true
        file_input.name  =   "Filename"
        file_input.string=   "filename"
        return [file_input]
    end 
end

class Gunzip_decompress < Gunzip
	def initialize
		super
		@title 			= "Uncompress Gunzip File"
		@ENABLED		=	true
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

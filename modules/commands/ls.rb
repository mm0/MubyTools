#!/usr/bin/ruby
#
	require_relative '../unix'
	require_relative '../command'

class Ls
include Unix
include Command
	

	def initialize
		init
		@sort 			=	0
		@ENABLED		=	false
		@category		=	"Local CLI Commands"
		@sub_category 	=	"Commands to be executed locally through a Shell"
		@command_type	=	Sudo
	end 

	def can_use?
		return installed?  
	end
	def installed? 
		super
		@@binary = `which ls`
	end
end

class Ls_list < Ls
	def initialize
		super
		@ENABLED		=	true
		@sort 			= 	100
		@command		=	"ls -la" 
		@title			=	"List Files" 
		@description	=	"Outputs contents of a directory passed as input"
		@shortcut		=	"ls_list"
		@category		=	"Local CLI Commands"
		@sub_category 	=	"Commands to be executed locally through a Shell"
		@command_type	=	Current_User
	end
end

class Ls_newest_file < Ls
	def initialize
		super
		@ENABLED		=	true
		@sort 			= 	100
		@command		=	"ls -ld -rt {directory}/* | tail -1 "
		@title			=	"List Newest filename (full path)"
		@shortcut		=	"ls_newest_file_full_path"
		@description	=	"Outputs the latest modified file in the directory passed as input"
		@category		=	"Local CLI Commands"
		@sub_category 	=	"Commands to be executed locally through a Shell"
		@command_type	=	Current_User	
	end

	def get_input_array
		dir_input 		= TTY_input.new
		dir_input.required = true
		dir_input.name	= 	"Directory"
		dir_input.string= 	"directory"
		return [dir_input]
	end
end

#!/usr/bin/ruby
#
	require_relative '../unix'
	require_relative '../command'

class SCP
include Unix
include Command
	

	def initialize
		init
		@sort 			=	0
		@ENABLED		=	false	
		@title			=	"List Files" 
		@shortcut		=	"ls"
		@description	=	"Outputs contents of a directory passed as input"
		@category		=	"SCP Commands"
		@sub_category 	=	"Commands to be executed locally through a Shell"
		@command_type	=	Current_User
	end 

	def can_use?
		return installed?  
	end
	def installed? 
		super
		@@binary = `which scp`
		String.try_convert @@binary
	end
end


class SCP_retrive < SCP
	def initialize
		super
		init
		@sort 			= 	200
		@title			=	"Retrieve a remote file through SCP"
		@command		=	"scp {server}:{filename} {destination}"
		@shortcut		=	"scp_retrieve"
		@description	=	"Retrieve a remote file through SCP"
	end
    def get_input_array
        server_input       = TTY_input.new
        server_input.required = true
        server_input.name  =   "Server Address"
        server_input.string=   "server"
        filename_input       = TTY_input.new
        filename_input.required = true
        filename_input.name  =   "Remote Path/Filename"
        filename_input.string=   "filename"
        destination_input       = TTY_input.new
        destination_input.required = true
        destination_input.name  =   "Local Destination"
        destination_input.string=   "destination"
        return [server_input,
				filename_input,
				destination_input]
    end 
end

class SCP_send < SCP
	def initialize
		super
		init
		@sort 			= 	100
		@title			=	"Send a local file to remote server through SCP"
		@command		=	"scp {filename} {server}:{destination}"
		@shortcut		=	"scp_send"
		@description	=	"Send a local file to Remote server through SCP"
	end
    def get_input_array
        server_input       = TTY_input.new
        server_input.required = true
        server_input.name  =   "Server Address"
        server_input.string=   "server"
        filename_input       = TTY_input.new
        filename_input.required = true
        filename_input.name  =   "Local Path/Filename"
        filename_input.string=   "filename"
        destination_input       = TTY_input.new
        destination_input.required = true
        destination_input.name  =   "Remote Destination Path/File"
        destination_input.string=   "destination"
        return [server_input,
				filename_input,
				destination_input]
	end
end

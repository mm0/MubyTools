#!/usr/bin/ruby
#
	require_relative '../unix'
	require_relative '../command'

class SSH
include Unix
include Command

	def initialize
		init
		@sort 			=	0
		@category		=	"Local CLI Commands"
		@sub_category 	=	"Commands to be executed locally through a Shell"
		@command_type	=	Current_User
	end 

	def can_use?
		return installed?  
	end
	def installed? 
		super
		@@binary = `which ssh`
	end
end

class SSH_connect < SSH
	def initialize
		super
		@ENABLED		= true
		@sort 			= 100
		@command		=	"ssh {user}@{server}"
		@title			=	"Connect to Remote Server"
		@shortcut		=	"ssh_connect"
		@description	=	"Connect to a remote ssh server with credentials"
	end

    def get_input_array
        user_input       = TTY_input.new
        user_input.required = true
        user_input.name  =   "User"
        user_input.string=   "user"
        server_input       = TTY_input.new
        server_input.required = true
        server_input.name  =   "Server Address"
        server_input.string=   "server"
        return [user_input,server_input]
    end 
end

class SSH_remote_command < SSH
	def initialize
		super
		@title 			= "Compress File(s)"
		@ENABLED		= true
		@description 	= "Send Command to Remote Server via SSH"
		@shortcut 		= "ssh_execute_remote_cmd"
		@command		=	"ssh $1 '$2'"
		@sort 			= 200
		@category		= "Remote CLI Commands"
		@sub_category 	= "Commands to be executed remotely through SSH"
	end
end

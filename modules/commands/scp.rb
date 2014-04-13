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
		@category		=	"Local CLI Commands"
		@sub_category 	=	"Commands to be executed locally through a Shell"
		@command_type	=	"UNIX"
	end 

	def can_use?
		return installed?  
	end
	def installed? 
		super
		@@binary = `which scp`
	end
end


class SCP_retrive < SCP
	def initialize
		super
		@ENABLED		=	true
		@sort 			= 	100
		@title			=	"Retrieve a remote file through SCP"
		@shortcut		=	"scp_retrieve"
		@description	=	"Retrieve a remote file through SCP"
	end
end

class SCP_send < SCP
	def initialize
		super
		@ENABLED		=	true
		@sort 			= 	100
		@title			=	"Send a local file to remote server through SCP"
		@shortcut		=	"scp_send"
		@description	=	"Send a local file to Remote server through SCP"
	end
end

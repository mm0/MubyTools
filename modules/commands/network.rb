#!/usr/bin/ruby
#
	require_relative '../unix'
	require_relative '../command'

class Networking
include Unix
include Command

	def initialize
		init
		@sort 			=	0
		@category		=	"Local CLI Commands"
		@sub_category 	=	"Commands to be executed locally through a Shell"
		@command_type	=	"UNIX"
	end 

	def can_use?
		return installed?  
	end
	def installed? 
		super
		@@binary = `which echo`
	end
end

class Add_to_local_hosts < Networking
	def initialize
		super
		@ENABLED		= true
		@sort 			= 100
		@title			=	"Set Local /etc/hosts File for development"
		@shortcut		=	"set_local_hosts"
		@description	=	"Set Local /etc/hosts File for development"
	end
end

class Remove_from_local_hosts < Networking
	def initialize
		super
		@title 			= "Remove entries from Local Hosts file"
		@ENABLED		= true
		@description 	= "Un-Set Local /etc/hosts File for development.  One input: string to search for"
		@shortcut 		= "unset_local_hosts"
		@sort 			= 200
	end
end

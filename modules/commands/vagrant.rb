#!/usr/bin/ruby
#
	require_relative '../unix'
	require_relative '../command'

class Vagrant
include Unix
include Command

	def initialize
		init
		@sort 			=	0
		@category		=	"Vagrant(up) Commands"
		@sub_category 	=	"Commands to adjust Vagrant development environment"
		@command_type	=	Current_User
	end 

	def can_use?
		return installed?  
	end
	def installed? 
		super
		@@binary = `which vagrant`
	end
end

class Vagrant_start < Vagrant
	def initialize
		super
		@ENABLED		= true
		@sort 			= 100
		@title			=	"Start Vagrant Server "
		@shortcut		=	"vagrant_start"
		@description	=	"Start Vagrant Server "
		@command		=	"cd $1; vagrant up "
	end
end

class Vagrant_pause < Vagrant
	def initialize
		super
		@ENABLED		= true
		@sort 			= 200
		@title			=	"Pause Vagrant Server "
		@shortcut		=	"vagrant_pause"
		@description	=	"Suspend Vagrant Server "
		@command		=	"cd $1; vagrant suspend"
	end
end

class Vagrant_stop < Vagrant
	def initialize
		super
		@ENABLED		= true
		@sort 			= 300
		@title			=	"Stop Vagrant Server "
		@shortcut		=	"vagrant_stop"
		@description	=	"Halt Vagrant Server "
		@command		=	"cd $1; vagrant halt"
	end
end

class Vagrant_execute_remote_cmd < Vagrant
	def initialize
		super
		@ENABLED		= true
		@sort 			= 300
		@title			=	"Send Command to Vagrant Server via SSH"
		@shortcut		=	"vagrant_execute_cmd"
		@description	=	"Send Command to Vagrant Server via SSH"
	end
end


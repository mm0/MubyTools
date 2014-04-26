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
		@ENABLED		=	false
		@category		=	"Vagrant Commands"
		@sub_category 	=	"Commands to adjust Vagrant development environment"
		@command_type	=	Current_User
	end 

	def can_use?
		return installed?  
	end
	def installed? 
		super
		@@binary = `which vagrant`
		return @@binary
	end
end

class Vagrant_start < Vagrant
	def initialize
		super
		init
		@sort 			= 100
		@title			=	"Start Vagrant Server "
		@shortcut		=	"vagrant_start"
		@description	=	"Start Vagrant Server "
		@command		=	"cd {directory}; vagrant up "
	end
    def get_input_array
        directory_input       = TTY_input.new
        directory_input.required = true
        directory_input.name  =   "Directory"
        directory_input.string=   "directory"
        return [directory_input]
    end 
end

class Vagrant_pause < Vagrant
	def initialize
		super
		init
		@sort 			= 200
		@title			=	"Pause Vagrant Server "
		@shortcut		=	"vagrant_pause"
		@description	=	"Suspend Vagrant Server "
		@command		=	"vagrant suspend"
	end
end

class Vagrant_stop < Vagrant
	def initialize
		super
		init
		@sort 			= 300
		@title			=	"Stop(halt) Vagrant Server "
		@shortcut		=	"vagrant_stop"
		@description	=	"Halt Vagrant Server "
		@command		=	"vagrant halt"
	end
end

class Vagrant_provision < Vagrant
	def initialize
		super
		init
		@sort 			= 400
		@title			=	"Provision Vagrant Server "
		@shortcut		=	"vagrant_provision"
		@description	=	"Provision Vagrant Server "
		@command		=	"vagrant provision"
	end
end

class Vagrant_execute_remote_cmd < Vagrant
	def initialize
		super
		init
		@sort 			= 500
		@title			=	"Send Command to Vagrant Server via SSH"
		@shortcut		=	"vagrant_execute_cmd"
		@description	=	"Send Command to Vagrant Server via SSH"
		@command		=	"vagrant ssh -c '{command}'"
	end
    def get_input_array
        command_input       = TTY_input.new
        command_input.required = true
        command_input.name  =   "Command"
        command_input.string=   "command"
        return [command_input]
    end 
end


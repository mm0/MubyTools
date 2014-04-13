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
		@command_type	=	Sudo
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
		@command		=	"echo -e '{hostname}\t{ip}' >> /etc/hosts"
		@description	=	"Set Local /etc/hosts File for development"
	end
    def get_input_array
        entry_input       = TTY_input.new
        entry_input.required = true
        entry_input.name  =   "Hostname"
        entry_input.string=   "hostname"
        ip_input       = TTY_input.new
        ip_input.required = true
        ip_input.name  =   "IP"
        ip_input.string=   "ip"
        return [entry_input,ip_input]
    end 
end

class Remove_from_local_hosts < Networking
	def initialize
		super
		@title 			= "Remove entries from Local Hosts file"
		@ENABLED		= true
		@command		= "grep -v '{hostname}' /etc/hosts > /tmp/hosts; mv /tmp/hosts /etc"
		@description 	= "Un-Set Local /etc/hosts File for development.  One input: string to search for"
		@shortcut 		= "unset_local_hosts"
		@sort 			= 200
	end
    def get_input_array
        entry_input       = TTY_input.new
        entry_input.required = true
        entry_input.name  =   "Hostname"
        entry_input.string=   "hostname"
        return [entry_input]
	end
end

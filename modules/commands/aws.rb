#!/usr/bin/ruby
#
    require_relative '../unix'
    require_relative '../command'

class AWS
	include Unix
	include Command

    def initialize
        init
        @sort           =   0   
        @ENABLED 		=   false
        @title          =   "AWS"
        @shortcut       =   "aws"
        @description    =   "Amazon Web Services Command"
        @category       =   "UNIX"
        @sub_category   =   "AWS"
        @command_type   =   "UNIX"
    end 

    def installed?
		`which aws_tools`
    end 

    def can_use?
        return installed?  
    end 

end



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


=begin
              "EC2" : [ 
                    {   
                        "command":"setup_ec2_command_line_tools" ,
                        "title" : "Setup EC2 Command Line Tools" ,
                        "description" :  "Setup EC2 Command Line Tools"  ,
                        "type" : ""
                    },  
                    {   
                        "command":"show_servers" ,
                        "title" : "List EC2 Servers" ,
                        "description" :  "Lists EC2 Servers" ,
                        "type" : ""
                    },  
                    {   
                        "command":"show_images" ,
                        "title" : "List EC2 Snapshots" ,
                        "description" :  "Lists EC2 Snapshots" ,
                        "type" : ""
                    },  
                    {   
                        "command":"show_emis" ,
                        "title" : "List EC2 EMIs" ,
                        "description" :  "Lists EC2 EMIs" ,
                        "type" : ""
                    },  
                    {   
                        "command":"open_ec2_port" ,
                        "title" : "Open EC2 Port" ,
                        "description" :  "Open EC2 Port" ,
                        "type" : ""
                    },  
                    {   
                        "command":"close_ec2_port" ,
                        "title" : "Close EC2 Port" ,
                        "description" :  "Close EC2 Port" ,
                        "type" : ""
                    },  

                ],
=end

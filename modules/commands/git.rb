#!/usr/bin/ruby
#
    require_relative '../unix'
    require_relative '../command'

class Git
	include Unix
	include Command

    def initialize
        init
        @sort           =   0   
        @ENABLED 		=   false
        @title          =   "Git"
        @shortcut       =   "git"
        @description    =   "Git command"
        @category       =   "Git"
        @category_desc	=   "Git"
        @sub_category   =   "Git"
        @command_type   =   "UNIX"
    end 

    def installed?
        require 'rbconfig'
        void = RbConfig::CONFIG['host_os'] =~ /msdos|mswin|djgpp|mingw/ ? 'NUL' : '/dev/null'
        system "git --version >>#{void} 2>&1"
    end 

    def can_use?
        return installed?  
    end 

end


=begin 

{
                        "command":"git_pull" ,
                        "title" : "Git Pull" ,
                        "description" :  "Git Pull" ,
                        "type" : ""
                    },
                    {
                        "command":"git_quick_commit" ,
                        "title" : "Quick Add+Commit+Push To Github",
                        "description" :  "Quick Add+Commit+Push To Github",
                        "type" : ""
                    },

=end

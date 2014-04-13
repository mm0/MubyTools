#!/usr/bin/ruby

module Git
	def Git.installed?
		require 'rbconfig'
		void = RbConfig::CONFIG['host_os'] =~ /msdos|mswin|djgpp|mingw/ ? 'NUL' : '/dev/null'
		system "git --version >>#{void} 2>&1"
	end

    def can_use?
        return installed?  
    end 
end

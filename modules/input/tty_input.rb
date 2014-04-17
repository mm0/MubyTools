#!/usr/bin/ruby

class TTY_input 
include Input
	def initialize
		@type = self
	end

	def load_value
		super
		if(!@loaded) 
			puts ("Enter " + @name + " >").green.underline
			@value = STDIN.gets.chomp
			@loaded = true
		end
	end

end

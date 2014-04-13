#!/usr/bin/ruby

module Input
	attr_accessor :type		#pointer to extended class  
	attr_accessor :optional #false/true
	attr_accessor :required #false/true
	attr_accessor :loaded = false
	attr_accessor :value

	def is_loaded?
		return @loaded
	end
end

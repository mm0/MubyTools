#!/usr/bin/ruby

module Input
	attr_accessor :type		#pointer to extended class  
	attr_accessor :optional #false/true
	attr_accessor :required #false/true
	attr_accessor :loaded 
	attr_accessor :value
	attr_accessor :string
	attr_accessor :name

	def is_loaded?
		return @loaded
	end
end

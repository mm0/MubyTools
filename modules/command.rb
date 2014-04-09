
module Command
	@@state = "ENABLED"
	attr_accessor :sort
	attr_accessor :state
	attr_accessor :title
	attr_accessor :shortcut
	attr_accessor :description
	attr_accessor :category
	attr_accessor :sub_category
	attr_accessor :type

	#class Input_Handler
	#end
	def init
		if !can_use?
			@@state = "DISABLED"
			puts "disabled"
		end
	end



	def has_inputs?

	end

	def can_use?

	end

	def execute 

	end
	
end

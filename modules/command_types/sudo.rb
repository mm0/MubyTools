#/usr/bin/ruby

require_relative "../command_types"

class Sudo
	include Muby_Command_Types
	def initialize 
		init
		@id			 = 2
		@name 		 = "Super User"
		@title 		 = "Super User"
		@description = "Sudo command privileges required"
	end
end

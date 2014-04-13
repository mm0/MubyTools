#/usr/bin/ruby

require_relative "../command_types"

class Current_User 
	include Muby_Command_Types
	def initialize 
		init
		@id 		 = 1 
		@name 		 = "Current User"
		@title 		 = "Current User"
		@description = "Regular non-sudo command privileges required"
	end
end

#!/usr/bin/ruby
#
	require_relative '../unix'
	require_relative '../command'

class MYSQL
include Unix
include Command

	def initialize
		init
		@sort 			=	0
		@category		=	"Database Commands"
		@sub_category 	=	"MySQL Database Commands"
		@command_type	=	Current_User
	end 

	def can_use?
		return installed?  
	end
	def installed? 
		super
		@@binary = `which ssh`
	end
end

class MYSQL_import < MYSQL
	def initialize
		super
		@ENABLED		= true
		@sort 			= 100
		@title			=	"Import local MySQL DB"
		@shortcut		=	"mysql_import"
		@description	=	"Import local MySQL DB"
		@command		=	"mysql -u$1 -p'$2' $4 < $3"
	end
end


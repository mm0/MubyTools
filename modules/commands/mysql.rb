#!/usr/bin/ruby
#
	require_relative '../unix'
	require_relative '../command'

class MYSQL
include Unix
include Command

	def initialize
		@sort 			=	0
		@category		=	"Database Commands"
		@sub_category 	=	"MySQL Database Commands"
		@command_type	=	Current_User
		@ENABLED 		=	false
	end 

	def can_use?
		return self.installed?  
	end
	def installed? 
		super
		@@binary = `which mysql`.chomp
		return @@binary.length
	end
end

class MYSQL_import < MYSQL
	#TODO: Implement optional TTY_input 
	def initialize
		super
		init
		@sort 			= 100
		@title			=	"Import local MySQL DB"
		@shortcut		=	"mysql_import"
		@description	=	"Import local MySQL DB"
		@command		=	"mysql -u{username} -p'{password}' {database} < {filename}"
	end
	def get_input_array
		username_input 	=	TTY_input.new
		username_input.required 	=	true
		username_input.name 	=	"Username"	
		username_input.string 	=	"username"	
		password_input 	=	TTY_input.new
		password_input.required 	=	true
		password_input.name 	=	"Password"	
		password_input.string 	=	"password"	
		database_input 	=	TTY_input.new
		database_input.required 	=	true
		database_input.name 	=	"Database"	
		database_input.string 	=	"database"	
		filename_input 	=	TTY_input.new
		filename_input.required 	=	true
		filename_input.name 	=	"Filename"	
		filename_input.string 	=	"filename"	
		return [username_input,
				password_input,
				database_input,
				filename_input]
	end
		
end

class MYSQL_dump < MYSQL
	#TODO: Implement optional TTY_input 
	def initialize
		super
		init
		@sort 			= 200
		@title			=	"Dump local MySQL DB to file"
		@shortcut		=	"mysql_dump"
		@description	=	"Dump local MySQL DB to file"
		@command		=	"mysqldump -u{username} -p'{password}' {database} > {filename}"
	end
	def installed? 
		super
		@@binary = `which mysqldump`.chomp
		return @@binary.length
	end
	def get_input_array
		username_input 	=	TTY_input.new
		username_input.required 	=	true
		username_input.name 	=	"Username"	
		username_input.string 	=	"username"	
		password_input 	=	TTY_input.new
		password_input.required 	=	true
		password_input.name 	=	"Password"	
		password_input.string 	=	"password"	
		database_input 	=	TTY_input.new
		database_input.required 	=	true
		database_input.name 	=	"Database Options (--all-databases | --database dbname "	
		database_input.string 	=	"database"	
		filename_input 	=	TTY_input.new
		filename_input.required 	=	true
		filename_input.name 	=	"Filename"	
		filename_input.string 	=	"filename"	
		return [username_input,
				password_input,
				database_input,
				filename_input]
	end
end
		

class MYSQL_export_local_to_remote < MYSQL
	#TODO: Implement optional TTY_input 
	def initialize
		super
		init
		@sort 			= 300
		@title			=	"Export Local MySQL DB Dump to Remote Server"
		@shortcut		=	"export_local_db"
		@description	=	"Export Local MySQL DB Dump to Remote Server"
		@command		=	"mysql -u{username} -p'{password}' {database} < {filename}"
	end
	def get_input_array
		username_input 	=	TTY_input.new
		username_input.required 	=	true
		username_input.name 	=	"Username"	
		username_input.string 	=	"username"	
		password_input 	=	TTY_input.new
		password_input.required 	=	true
		password_input.name 	=	"Password"	
		password_input.string 	=	"password"	
		database_input 	=	TTY_input.new
		database_input.required 	=	true
		database_input.name 	=	"Database"	
		database_input.string 	=	"database"	
		filename_input 	=	TTY_input.new
		filename_input.required 	=	true
		filename_input.name 	=	"Filename"	
		filename_input.string 	=	"filename"	
		return [username_input,
				password_input,
				database_input,
				filename_input]
	end
		
end

class MYSQL_retrieve_remote_db < MYSQL
	#TODO: Implement optional TTY_input 
	def initialize
		super
		init
		@sort 			= 400
		@title			=	"Retrieve remote MySQL DB Dump"
		@shortcut		=	"get_remote_db"
		@description	=	"Retrieve remote MySQL DB Dump"
		@command		=	"mysql -u{username} -p'{password}' {database} < {filename}"
	end
	def get_input_array
		username_input 	=	TTY_input.new
		username_input.required 	=	true
		username_input.name 	=	"Username"	
		username_input.string 	=	"username"	
		password_input 	=	TTY_input.new
		password_input.required 	=	true
		password_input.name 	=	"Password"	
		password_input.string 	=	"password"	
		database_input 	=	TTY_input.new
		database_input.required 	=	true
		database_input.name 	=	"Database"	
		database_input.string 	=	"database"	
		filename_input 	=	TTY_input.new
		filename_input.required 	=	true
		filename_input.name 	=	"Filename"	
		filename_input.string 	=	"filename"	
		return [username_input,
				password_input,
				database_input,
				filename_input]
	end
		
end

#TODO: REPLICATE DB
#TODO: SET ROOT Password
#TODO: Change User Password


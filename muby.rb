#!/usr/bin/ruby

require "colorize"
require "sqlite3"
require "json" 

class SQLITE_ADAPTER 
	@@version = 0.1
	@@db_conn
	@@database_file = "data.db"
	@db 
	
	def add_command str, title,description,type,category
		puts @db.execute "INSERT INTO admin_commands VALUES(null,?,?,?,?,?) ", str,title,description,type,category

	end
	
	def connect
		@db = SQLite3::Database.new @@database_file
	end
	
	def first_install 
		puts 'test'
		begin
			@db = SQLite3::Database.new @@database_file
			@db.execute "CREATE TABLE IF NOT EXISTS admin_config (Id INTEGER PRIMARY KEY, Name TEXT, Option TEXT)"
			@db.execute "CREATE TABLE IF NOT EXISTS admin_servers (Id INTEGER PRIMARY KEY, Name TEXT, Host TEXT, Port INTEGER)"
			@db.execute "CREATE TABLE IF NOT EXISTS admin_databases (Id INTEGER PRIMARY KEY, Name TEXT, Host TEXT, Port INTEGER,Type TEXT)"
			@db.execute "CREATE TABLE IF NOT EXISTS admin_ssh_keys (Id INTEGER PRIMARY KEY, User TEXT, Key TEXT, Type TEXT)"
			@db.execute "CREATE TABLE IF NOT EXISTS admin_ssh_keys_server (Server_Id INTEGER , Ssh_Key_Id INTEGER, Enabled BOOLEAN)"
			@db.execute "CREATE TABLE IF NOT EXISTS admin_commands (Command_Id INTEGER PRIMARY KEY, Command TEXT,Title TEXT, Description TEXT, Type TEXT,Category TEXT)"
			@db.execute "CREATE TABLE IF NOT EXISTS admin_command_type (Type TEXT , Name TEXT )"
		rescue SQLite3::Exception => e 
			puts "Exception occured"
			puts e
		ensure
			#@db.close if @db
		end

	end
	
	def get_servers
		q= "SELECT * FROM admin_servers";
		r = @db.execute q
	end
	
	def get_databases
		q= "SELECT * FROM admin_databases";
		r = @db.execute q

	end
	
	def get_keys
		q= "SELECT * FROM admin_ssh_keys";
		r = @db.execute q

	end
	
	def get_config
		q= "SELECT * FROM admin_config"
		r = @db.execute q
	end

	def update_config field, value
		q = "UPDATE admin_config SET "+field+"='"+value+"'"
		r = @db.execute q
	end

	def add_server 
		q = " INSERT INTO admin_servers ( ) VALUES ( )"
		r = @db.execute q
	end

	def add_database
		q = " INSERT INTO admin_databases ( ) VALUES ( )"
		r = @db.execute q
	end

	def add_key
		q = " INSERT INTO admin_ssh_keys ( ) VALUES ( )"
		r = @db.execute q

	end

	def assign_key_to_server key_id,server_id  
		q = " INSERT INTO admin_ssh_keys_servers (key_id,server_id ) VALUES ("+key_id+","+server_id+" )"
		r = @db.execute q
	end
end

class ADMIN_HELPER 
	@@version = 0.1
	@@database_file = "./data.db"
	@@default_commands = "default_commands.json"
	@@SQL
	@@config 
	@@commands 

	def install_sqlite_db
		@@SQL.first_install	
	end

	def load_config
		@@config = @@SQL.get_config
	end

	def process_command command
		category = command['Category']
		str  = command['Command']
		title = command['Title']
		description = command['Description']
		type =  command['Type']
		#parse by % ex: scp %s %s %s 

	end

	def install_commands comms
		comms['Categories'].each {|key,v|
			v.each {|index,comm|
				category = key
				str  = index['command']
				title = index['title']
				description = index['description']
				type =  index['type']
				@@SQL.add_command str, title,description,category,type

			}
		}

	end

	def initialize 
		@@SQL = SQLITE_ADAPTER.new
		if !File.exists?(@@database_file)
			@@commands = JSON.parse(IO.read( @@default_commands) )
			self.install_sqlite_db
			self.install_commands @@commands
			
		else
			@@SQL.connect
			self.load_config
		end
		
		show_menu
	end

	def get_user_input	text,variable
		puts text+"> " 		
		data = gets 
		self.set_config variable,data
	end

	def connect_remote 

	end

	def send_remote_cmd 

	end

	def retrieve_remote_file 

	end

	def send_remote_file 

	end

	def connect_remote 

	end

	def set_local_hosts 

	end

	def unset_local_hosts 

	end

	def rsync_directories 

	end

	def dump_db 

	end

	def import_db 

	end

	def get_remote_db 

	end

	def export_local_db 

	end

	def git_pull 

	end

	def git_quick_commit 

	end

	def setup_ec2_command_line_tools 

	end

	def show_servers 

	end

	def show_images 

	end

	def show_emis 

	end

	def open_ec2_port 

	end

	def close_ec2_port 

	end

	def exit 

	end

	def show_menu
		i=0;
		@@commands['Categories'].each {|key,v|
			`clear`
			puts "\t"+"#{key}".green.underline
			v.each {|index,comm|
				puts "\t\t ["+"#{i}".red+"]\t>\t"+index['title'].cyan
				i+=1
		#		puts "\tdef #{index['command']} \n\n\tend\n\n"
			}
		}
	end

end

a = ADMIN_HELPER.new

#puts String.color_matrix

#!/usr/bin/ruby

require "colorize"
require "sqlite3"

class SQLITE_ADAPTER 
	@@version = 0.1
	@@db_conn
	@@database_file = "data.db"
	@db 
	
	def add_command str, title,description,category,type
		puts @db.execute "INSERT INTO admin_commands ('"+str+"','"+title+"','"+description+"','"+category+"','"+type+"')"

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
			@db.execute "CREATE TABLE IF NOT EXISTS admin_commands (Command_Id INTEGER , Command TEXT,Title TEXT, Description TEXT, Type TEXT,Category TEXT)"
			@db.execute "CREATE TABLE IF NOT EXISTS admin_command_type (Type TEXT , Name TEXT )"
		rescue SQLite3::Exception => e 
			puts "Exception occured"
			puts e
		ensure
			@db.close if @db
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
	@@SQL
	@@config 

	def install_sqlite_db
		@@SQL.first_install	
	end

	def load_config
		@@config = @@SQL.get_config

	end
	@@commands = { "Categories" => {
				"Unix"=> [
					{
						"command"=>"connect_remote" ,
						"title" => 'Connect to Remote Server' ,
						"description" => 'Connect to Remote Server' ,
						"type" => ""
					},
					{
						"command"=>"send_remote_cmd" ,
						"title" => "Send Command to Remote Server via SSH" ,
						"description" => 'Dump local MySQL DB' ,
						"type" => ""
					},
					{
						"command"=>"retrieve_remote_file" ,
						"title" => 'Retrieve a remote file through SCP' ,
						"description" => 'Retrieve a remote file through SCP' ,
						"type" => ""
					},
					{
						"command"=>"send_remote_file" ,
						"title" => 'Send a file to remote server through SCP' ,
						"description" => 'Send a file to remote server through SCP' ,
						"type" => ""
					},
					{
						"command"=>"connect_remote" ,
						"title" => 'Dump local MySQL DB' ,
						"description" => 'Dump local MySQL DB' ,
						"type" => ""
					},
					{
						"command"=>"set_local_hosts" ,
						"title" => "Set Local /etc/hosts File for development" ,
						"description" =>  "Set Local /etc/hosts File for development" ,
						"type" => ""
					},
					{
						"command"=>"unset_local_hosts" ,
						"title" => "Unset Local /etc/hosts File for development" ,
						"description" =>  "Unset Local /etc/hosts File for development" ,
						"type" => ""
					},
					{
						"command"=>"rsync_directories" ,
						"title" => "Rsync Local Directories" ,
						"description" =>  "Rsync Local Directories" ,
						"type" => ""
					}
					#'Rsync Dev->Staging'
					#'Rsync Staging->Production' 
					#'Git to Dev'
					#'Git to Staging'
					#'Set Dev'
					#'Set Staging'   
					#'Exit'
						],
				"MySQL" => [
					{
						"command"=>"dump_db" ,
						"title" => 'Dump local MySQL DB' ,
						"description" => 'Dump local MySQL DB' ,
						"type" => ""
					},
					{
						"command"=>"import_db" ,
						"title" => 'Import local MySQL DB' ,
						"description" => 'Import local MySQL DB' ,
						"type" => ""
					},
					{
						"command"=>"get_remote_db" ,
						"title" => 'Retrieve remote MySQL DB Dump' ,
						"description" =>  'Retrieve remote MySQL DB Dump' ,
						"type" => ""
					},
					{
						"command"=>"export_local_db" ,
						"title" => 'Export Local MySQL DB Dump to Remote Server' ,
						"description" =>  'Export Local MySQL DB Dump to Remote Server' ,
						"type" => ""
					},
					#'Replicate DB'
				],
				"Git" => [
					{
						"command"=>"git_pull" ,
						"title" => 'Git Pull' ,
						"description" =>  'Git Pull' ,
						"type" => ""
					},
					{
						"command"=>"git_quick_commit" ,
						"title" => "Quick Add+Commit+Push To Github",
						"description" =>  "Quick Add+Commit+Push To Github",
						"type" => ""
					},
				],
				"EC2" => [
					{
						"command"=>"setup_ec2_command_line_tools" ,
						"title" => 'Setup EC2 Command Line Tools' ,
						"description" =>  'Setup EC2 Command Line Tools'  ,
						"type" => ""
					},
					{
						"command"=>"show_servers" ,
						"title" => 'List EC2 Servers' ,
						"description" =>  'Lists EC2 Servers' ,
						"type" => ""
					},
					{
						"command"=>"show_images" ,
						"title" => 'List EC2 Snapshots' ,
						"description" =>  'Lists EC2 Snapshots' ,
						"type" => ""
					},
					{
						"command"=>"show_emis" ,
						"title" => 'List EC2 EMIs' ,
						"description" =>  'Lists EC2 EMIs' ,
						"type" => ""
					},
					{
						"command"=>"open_ec2_port" ,
						"title" => 'Open EC2 Port' ,
						"description" =>  'Open EC2 Port' ,
						"type" => ""
					},
					{
						"command"=>"close_ec2_port" ,
						"title" => 'Close EC2 Port' ,
						"description" =>  'Close EC2 Port' ,
						"type" => ""
					},

				],
				"Exit" => [
					{
						"command"=>"exit" ,
						"title" => 'exit' ,
						"description" =>  '' ,
						"type" => ""
					},
				]
				
			}
	}

	def process_command command

	end


	def initialize 
		@@SQL = SQLITE_ADAPTER.new
		if !File.exists?(@@database_file)
			self.install_sqlite_db
			
		else
			@@SQL.connect
			self.load_config
		end
		
		show_menu
	end

	def asd

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

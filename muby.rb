#!/usr/bin/ruby

require "colorize"
require "sqlite3"

class ADMIN_HELPER 
	@@version = 0.1
	@@database_file = "data.db"
	def install_sqlite_db
		begin
			db = SQLite3::Database.new @@database_file
			db.execute "CREATE TABLE IF NOT EXISTS admin_config (Id INTEGER PRIMARY KEY, Name TEXT, Option TEXT)"
		rescue SQLite3::Exception => e 
			puts "Exception occured"
			puts e
		ensure
			db.close if db
		end

	end
	def load_sqlite_db
		db = SQLite3::Database.open @@database_file
		 a = db.execute "SELECT * FROM admin_config"
 		a.each do |k|
			p k
		end
	end
	@@commands = { "Categories" => {
				"Unix"=> [
					{
						"command"=>"connect_remote" ,
						"title" => 'Connect to Remote Server' ,
						"description" => 'Connect to Remote Server' ,
					},
					{
						"command"=>"send_remote_cmd" ,
						"title" => "Send Command to Remote Server via SSH" ,
						"description" => 'Dump local MySQL DB' ,
					},
					{
						"command"=>"retrieve_remote_file" ,
						"title" => 'Retrieve a remote file through SCP' ,
						"description" => 'Retrieve a remote file through SCP' ,
					},
					{
						"command"=>"send_remote_file" ,
						"title" => 'Send a file to remote server through SCP' ,
						"description" => 'Send a file to remote server through SCP' ,
					},
					{
						"command"=>"connect_remote" ,
						"title" => 'Dump local MySQL DB' ,
						"description" => 'Dump local MySQL DB' ,
					},
					{
						"command"=>"set_local_hosts" ,
						"title" => "Set Local /etc/hosts File for development" ,
						"description" =>  "Set Local /etc/hosts File for development" ,
					},
					{
						"command"=>"unset_local_hosts" ,
						"title" => "Unset Local /etc/hosts File for development" ,
						"description" =>  "Unset Local /etc/hosts File for development" ,
					},
					{
						"command"=>"rsync_directories" ,
						"title" => "Rsync Local Directories" ,
						"description" =>  "Rsync Local Directories" ,
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
					},
					{
						"command"=>"import_db" ,
						"title" => 'Import local MySQL DB' ,
						"description" => 'Import local MySQL DB' ,
					},
					{
						"command"=>"get_remote_db" ,
						"title" => 'Retrieve remote MySQL DB Dump' ,
						"description" =>  'Retrieve remote MySQL DB Dump' ,
					},
					{
						"command"=>"export_local_db" ,
						"title" => 'Export Local MySQL DB Dump to Remote Server' ,
						"description" =>  'Export Local MySQL DB Dump to Remote Server' ,
					},
					#'Replicate DB'
				],
				"Git" => [
					{
						"command"=>"git_pull" ,
						"title" => 'Git Pull' ,
						"description" =>  'Git Pull' ,
					},
					{
						"command"=>"git_quick_commit" ,
						"title" => "Quick Add+Commit+Push To Github",
						"description" =>  "Quick Add+Commit+Push To Github",
					},
				],
				"EC2" => [
					{
						"command"=>"setup_ec2_command_line_tools" ,
						"title" => 'Setup EC2 Command Line Tools' ,
						"description" =>  'Setup EC2 Command Line Tools'  ,
					},
					{
						"command"=>"show_servers" ,
						"title" => 'List EC2 Servers' ,
						"description" =>  'Lists EC2 Servers' ,
					},
					{
						"command"=>"show_images" ,
						"title" => 'List EC2 Snapshots' ,
						"description" =>  'Lists EC2 Snapshots' ,
					},
					{
						"command"=>"show_emis" ,
						"title" => 'List EC2 EMIs' ,
						"description" =>  'Lists EC2 EMIs' ,
					},
					{
						"command"=>"open_ec2_port" ,
						"title" => 'Open EC2 Port' ,
						"description" =>  'Open EC2 Port' ,
					},
					{
						"command"=>"close_ec2_port" ,
						"title" => 'Close EC2 Port' ,
						"description" =>  'Close EC2 Port' ,
					},

				],
				"Exit" => [
					{
						"command"=>"exit" ,
						"title" => 'exit' ,
						"description" =>  '' ,
					},
				]
				
			}
	}

	def initialize 
		if File.exists?(@@database_file)
			self.install_sqlite_db
		else
			self.load_sqlite_db
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
				puts "\t\t [#{i}] > "+index['title']
				i+=1
		#		puts "\tdef #{index['command']} \n\n\tend\n\n"
			}
		}
	end

end

a = ADMIN_HELPER.new


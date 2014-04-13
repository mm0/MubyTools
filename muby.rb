#!/usr/bin/ruby

require "colorize"
require "sqlite3"
require "json" 
require "ostruct"
require "optparse"
require "pp"

PATH=File.expand_path(File.dirname(__FILE__))+"/"

class SQLITE_ADAPTER 
	@@version = 0.1
	@@db_conn
	@@database_file = PATH+"data.db"
	@@db_setup_file = PATH+"db_setup.sql"
	@@db_commands_setup_file = PATH+"db_commands_setup.sql"
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
			create = File.read(@@db_setup_file)
			commands = File.read(@@db_commands_setup_file)
			@db.execute_batch create
			@db.execute_batch commands
		rescue SQLite3::Exception => e 
			puts "Exception occured"
			puts e
		ensure
			#@db.close if @db
		end

	end
	
	def get_categories
		@db.results_as_hash = true
		q= "SELECT * FROM admin_categories";
		r = @db.execute q
	end
	def get_command_types
		@db.results_as_hash = true
		q= "SELECT * FROM admin_command_types";
		r = @db.execute q
	end
	def get_input_types
		@db.results_as_hash = true
		q= "SELECT * FROM admin_command_input_types";
		r = @db.execute q
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
		@db.results_as_hash = true
		q= "SELECT * FROM admin_config"
		return  @db.execute q
	end

	def get_commands
		@db.results_as_hash = true
		q= "SELECT * FROM admin_commands"
		return @db.execute q
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
	@@database_file = PATH+"./data.db"
	@@default_commands = "default_commands.json"
	@@SQL
	@@config 
	@@commands 
	@@categories
	@@input_types
	@@command_types

	def setup_sqlite_db
		@@SQL.first_install	
	end
	def load_config
		@@config = @@SQL.get_config
	end
	def load_commands
		@@commands= @@SQL.get_commands
	end
	def load_categories
		@@categories = @@SQL.get_categories
	end
	def load_input_types
		@@input_types= @@SQL.get_input_types
	end
	def load_command_types
		@@command_types= @@SQL.get_command_types
	end

	def load_all
		self.load_config
		#self.load_servers
		self.load_categories
		self.load_commands
		self.load_input_types
		self.load_command_types
		@@commands = @@commands.sort_by{|k|k['Category_Id']}
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

	def initialize options
		@@Options = options
		# TODO:  
		# change the SQL adapter to be an ABSTRACT Loading/Storage class
		@@SQL = SQLITE_ADAPTER.new
		if !File.exists?(@@database_file)
			#@@commands = JSON.parse(IO.read( @@default_commands) )
			self.setup_sqlite_db
		else
			@@SQL.connect
		end
		self.load_all

		if ARGV.length == 0
			self.show_category_menu
		else
			#cli format
			shortcut = ARGV[0]
			command = self.get_command_by_shortcut shortcut
			input_s = self.get_inputs command
			self.output_command (self.parse_command( command,input_s ))
		end
		
	end

	def get_command_expanded command
		if command['Command_Type_Id'].to_i == 2  then
			return "sudo bash -c \"$(cat <<EOFMUBY
			#{command['Command']} 
EOFMUBY
)\"" 
		else 
			return command['Command']
		end
	end
	def get_command_by_shortcut shortcut
		@@commands.each{|c| 
			if c['Shortcut'] == shortcut
				return c
			end
		}
	end

	def get_user_input	text,variable
		puts text+"> " 		
		data = STDIN.gets 
		self.set_config variable,data
	end

	def show_category_menu
		i=0
		clear
		@@categories.each{|key|
			puts "\t ["+"#{i}".red+"]\t>\t"+key['Title'].cyan
			i+=1
		}
		category_id = STDIN.gets
		self.show_menu category_id.chomp.to_i+1
	end
	
	def show_menu category_id
		i=0;
		##groups by categories
		#store the Id -> selector map
		clear
		local_commands = []
		@@commands.each {|key|
			if key['Category_Id']!= category_id.to_i
				next
			end
			local_commands[i] = key['Command_Id'].to_i
			puts "\t\t ["+"#{i}".red+"]\t>\t"+key['Title'].cyan
			i+=1
		}
		item = STDIN.gets.chomp.to_i
		command_id =  local_commands[item]
		@@commands.each{|command|
			if command['Command_Id'].to_i == command_id.to_i
				#get inputs
				p command
				inputs = self.get_inputs command
				#parse command
				parsed = self.parse_command(command,inputs)
				#output/execute command
				self.output_command ( parsed )
			end
		}
	end

	def get_inputs command
				#check inputs
				#check optional inputs
		inputs = command['Inputs'].to_i
		optional_inputs = command['Optional_Inputs'].to_i
		req = inputs - optional_inputs
		input_type = command['Input_Type_Id']
		#p ARGV
		input_s = []
		i=1
		if ARGV.length && ARGV[i] != nil then 
			until i > req
				if ARGV[i] then 
				input_s.push  ARGV[i]
				i+=1
				end
			end 
		end 
		#p req
		#req = 3
		while input_s.length < req do
			case input_type
			when false
			else
				puts "Enter input\t>\t"
				input_s.push STDIN.gets.chomp
			end
		end 
		return input_s
	end

	def execute_command cmd
		#p cmd
		p `#{cmd}`.chomp
	end

	def output_command cmd
		#p @@Options
		if !@@Options[:print_only]
			self.execute_command cmd
		else 
			self.print_command cmd
		end
	end

	def print_command cmd
		puts cmd
	end

	def parse_command cmd, inputs
		i=0 
		until !inputs[i] do 
			cmd['Command'] =  cmd['Command'].gsub(/\$#{Regexp.escape((i+1).to_s)}/,inputs[i])
			i+=1
		end
		return self.get_command_expanded cmd
	end

end

    options = OpenStruct.new
    options.library = []
    options.inplace = false
    options.encoding = "utf8"
    options.transfer_type = :auto
    options.verbose = false
    options = {}#OpenStruct.new
#puts String.color_matrix
OptionParser.new do |opts|
    opts.banner = "Banner"#""Usage init.rb [options]"+"\n"+usage
    opts.on("-f", "--force ","Forcefully Delete Backup") do |v| 
        options[:force] = v 
    end 

    opts.separator ""
    opts.separator "Common options:"
    opts.on("-v", "--[no]verbose","Run verbosely") do |v| 
        options[:verbose] = v 
    end 
    opts.on("-p", "--print","Print command only") do |v| 
		options[:print_only] = true
    end 
    opts.on("-s", "--silent","Run silently") do |v| 
        options[:silent] = v 
    end 
    
    opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end 

      # Another typical switch to print the version.
      opts.on_tail("--version", "Show version") do
        puts OptionParser::Version.join('.')
        exit
      end 
       
end.parse!
def clear 
	print "\e[2J\e[f"
end

def handle_input 
current_option = ARGV[0]
case current_option 
    when "backup-server"
        server_id = ARGV[1]
        if server_id == nil

        end
    when "backup-all"
        puts "Backing up all databases...".green
	else
	end
end

a = ADMIN_HELPER.new(options)

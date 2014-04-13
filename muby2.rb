#!/usr/bin/ruby
PATH=File.expand_path(File.dirname(__FILE__))+"/"
require 'pp'
require './lib/colorize'
require "./commands_loader.rb"
require "./modules/input.rb"


class MUBY_APP 
	@@version = 0.1
	@@database_file = PATH+"./data.db"
	@@Options
	@@commands 
	@@categories

	def initialize options
		@@Options = options
		loader = Muby_Commands_Loader.new
		loader.load_all
		@@categories 	= loader.get_categories
		@@commands 		= loader.get_commands
		if ARGV.length == 0
			clear
			puts "Welcome to Muby Tools".colorize(:color=>:green,:background=>:default).underline
			puts ("Version "+"#{@@version}").green.blink
			self.show_category_menu false
		else
			#cli format
			shortcut = ARGV[0]
			command = self.get_command_by_shortcut shortcut
			if command == false
				error_exit "Command not found"
			end
			command.output_only = true
			command.print_only = @@Options[:print_only] != nil ? true : false
			command.begin
		end
	end

	def get_command_by_shortcut shortcut
		@@commands.each{|c| 
			if c.shortcut == shortcut
				return c
			end
		}
		return false;
	end

	def get_user_input	text,variable
		puts text+"> " 		
		data = STDIN.gets 
		self.set_config variable,data
	end
	
	def graceful_exit
		#clear
		puts "Goodbye.".green
		Kernel.exit
	end

	def error_exit msg
		#clear
		puts "#{msg}".red
		puts "Goodbye.".green
		Kernel.exit
	end

	def show_category_menu should_clear=true
		i=1
		if should_clear
			clear
		end
		@@categories.each{|key|
			puts "\t ["+"#{i}".green+"]\t>\t"+key['title'].cyan
			i+=1
		}
		puts "\t ["+"x".red+"]\t>\t"+"Exit.".cyan
		puts "\r"+"Enter your selection: "
		category_id = STDIN.gets.chomp
		if category_id == "x" || category_id == "X" 
			self.graceful_exit
		end
		category_id = category_id.to_i-1
		if category_id == @@categories.length || @@categories[category_id] == nil || category_id < 0
			self.error_exit "Error: Selection not valid"
		end
		self.show_menu category_id
	end
	
	def show_menu category_id
		i=1;
		##groups by categories
		#store the Id -> selector map
		clear
		category = @@categories[category_id]['title']
		category_desc = @@categories[category_id]['sub']
		puts category.green.bold
		puts category_desc.green.underline
		local_commands = []
		@@commands.each {|key|
			if key.category != category
				next
			else
				local_commands[i-1] = key
				puts "\t ["+"#{i}".green+"]\t>\t"+key.title.cyan
			end
			i+=1
		}
		puts "\t ["+"x".red+"]\t>\t"+"Exit.".cyan
		puts "\t ["+"b".yellow+"]\t>\t"+"Back.".cyan
		puts "\r"+"Enter your selection: "
		item 	= STDIN.gets.chomp
		if item == "x" || item == "X" 
			self.graceful_exit
		elsif item == "b" || item == "B" 
			return self.show_category_menu
		end
		item = item.to_i
		if item == local_commands.length || local_commands[item] == nil || item == 0
			self.error_exit "Error: Selection not valid"
		end
		#command is set to the command object stored in local_commands array
		command	=  local_commands[item-1]
		#the goal here is to have the command object process itself
		command.print_only = @@Options[:print_only] != nil ? true : false
		command.begin
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


end


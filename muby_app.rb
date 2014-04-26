#!/usr/bin/ruby
PATH=File.expand_path(File.dirname(__FILE__))+"/"
require 'pp'
require_relative 'lib/colorize'
require_relative "commands_loader"
require_relative "modules/input"
require_relative "modules/options"


class MUBY_APP 
	@@version = 0.1
	@@Options
	@@commands 
	@@categories

	#return array to be passed to options_parser to check for input params passed as ARGV
	def get_commands_options
		options = []	
		#cycle through @@commands and retrieve input_array
		@@commands.each{|command| 
			if(command.respond_to?("get_input_array"))
				inputs = command.get_input_array
				inputs.each{|input|
					options.push( {"string"=>input.string,
									"description" => defined?(input.description) ?
												input.description : "Custom Variable" 
					})
				}
			end
		}
		return options
	end

	def initialize 
		loader = Muby_Commands_Loader.new
		loader.load_all
		@@categories 	= loader.get_categories
		@@commands 		= loader.get_commands
		
		@@Options 		= Muby_Options_Parser.new self.get_commands_options
		@@Options 		= @@Options.options
		if ARGV.length == 0
			#clear
			puts "Welcome to Muby Tools".colorize(:color=>:green,:background=>:default).underline
			puts ("Version "+"#{@@version}").green.blink
			self.show_category_menu false
		else
			#cli format
			shortcut 	= ARGV[0]
			command 	= self.get_command_by_shortcut shortcut
			if command == false
				error_exit "Command not found"
			end
			command.output_only = true
			self.process_command command
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
		i	=1
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
		i				= 1;
		##groups by categories
		#store the Id -> selector map
		clear
		category 		= @@categories[category_id]['title']
		category_desc 	= @@categories[category_id]['sub']
		puts category.green.bold
		puts category_desc.green.underline
		local_commands 	= []
		#print commands and shortcut numbers
		@@commands.each {|key|
			if key.category != category
				next
			else
				local_commands[i-1] = key
				puts "\t ["+"#{i}".green+"]\t>\t"+key.title.cyan
				i+=1
			end
		}
		puts "\t ["+"x".red+"]\t>\t"+"Exit.".cyan
		puts "\t ["+"b".yellow+"]\t>\t"+"Back.".cyan
		puts "\r"+"Enter your selection: "
		item 	= STDIN.gets.chomp
		#case exit program
		if item == "x" || item == "X" 
			self.graceful_exit
		#case go back
		elsif item == "b" || item == "B" 
			return self.show_category_menu
		end
		#account for 0 start array
		item 			= item.to_i-1
		if item == local_commands.length+1 || local_commands[item] == nil || item < 0
			self.error_exit "Error: Selection not valid"
		end
		#command is set to the command object stored in local_commands array
		command			= local_commands[item]
		#display which command was selected
		puts command.title.yellow
		#the goal here is to have the command object process itself
		self.process_command command
	end
	
	def process_command command
		command.print_only 	= @@Options.print_only 	!= nil ? true : false
		command.silent 		= @@Options.silent		!= nil ? true : false
		command.verbose		= @@Options.verbose		!= nil ? true : false
		command.options 	= @@Options
		command.begin
	end

end


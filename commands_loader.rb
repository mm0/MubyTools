#/usr/bin/ruby
#
require "./modules/command.rb"


class Muby_Commands_Loader
	@@categories			= [] #[{ 'Category_Id' => 1, 'Title' => 'Category', 'Description' => 'Test'}]
	@@command_types			= []
	@@commands				= []	#[{ 'Command_Id' => 1, 
								#	'Category_Id' => 1, 
								#	'Command' => 'asd',
								#	'Title' => 'Category', 
								#	'Description' => 'Test',
								#	'Type_Id' => 1 ,
								#	'Shortcut' => 'asd'}]
	@@commands_dir			= PATH + "/modules/commands/"
	@@command_types_dir		= PATH + "/modules/command_types/"
	
	def load_all
#		self.load_modules
		self.load_categories
		self.load_command_types
		self.load_commands
	end

	def load_command_types
		path = @@command_types_dir + "*.rb"
		Dir[path].each do |file|
			current_classes = Object.constants
			require file
			new_classes = Object.constants - current_classes
			new_classes.each do |cl|
				if cl.instance_of? Class
					cl = Kernel.const_get(cl)
					command_type = cl.new
					self.add_command_type(command_type)
				end
			end
		end
	end

	def load_categories

	end

	def load_commands
		path = @@commands_dir + "*.rb"
		Dir[path].each do |file|
			#Is this best way to determine which classes were loaded?
			current_classes = Object.constants
		#	pp file
			require file
			new_classes = Object.constants - current_classes
			new_classes.each do |cl|
				cl = Kernel.const_get(cl)
		#		pp cl.class
				if cl.instance_of? Class
		#			pp "class"
					command = cl.new
					if command.ENABLED then
						self.add_command(command)
						self.add_category(command)
					end
				end
			end
		end
		@@commands = @@commands.sort_by{|k|k.sort}
		#pp @@commands
	end

	def add_command command
		@@commands.push(command)
	end
	def add_command_type command_types
		@@command_types.push(command_types)
	end
	
	def add_category command
		category = command.category
		category_desc = command.category_desc
		sub_category = command.sub_category
		cmd = {'title' => category, 'description'  => category_desc, 'sub' => sub_category, 'id' => @@categories.length }
		#pp category
		if @@categories.find { |cats| cats['title'] == category } 
		else
			@@categories.push(cmd)
		end
		
	end

	def get_categories
		return @@categories
	end
	
	def get_commands
		return @@commands
	end

end


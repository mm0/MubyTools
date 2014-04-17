module Command
	attr_accessor :ENABLED
	attr_accessor :sort
	attr_accessor :state
	attr_accessor :title
	attr_accessor :print_only 
	attr_accessor :output_only 
	attr_accessor :shortcut
	attr_accessor :command
	attr_accessor :description
	attr_accessor :category
	attr_accessor :category_desc
	attr_accessor :sub_category
	attr_accessor :command_type
	attr_accessor :input_array
	attr_accessor :options

	#class Input_Handler
	#end
	def init
		if !can_use?
			@ENABLED= false
			puts "disabled"
		end
	end


	def begin
	#determine if inputs required 
	#if so prompt/check/load inputs
	#parse the command
		if !@output_only
			puts "Command has begun"
		end
		if has_inputs?
	
		else 
			@input_array = []
		end
		if can_use?
			parsed_command = self.parse_command
			self.output_command(parsed_command)

		end
	end


	def has_inputs?
		#most commands will require inputs
		return false;
	end

	def can_use?

	end
	
	def parse_command 
		cmd = @command
		@input_array = self.get_input_array
        @input_array.each { |input|
			input.options = @options
			input.load_value
            cmd	=  cmd.gsub(/\{#{Regexp.escape((input.string).to_s)}}/,input.value)
		}
        return self.get_command_expanded cmd
    end 

    def get_command_expanded cmd
		#TODO: this should happen in the command_type class
        if @command_type == Sudo
            cmd =  "sudo bash -c \"$(cat <<EOFMUBY
            #{cmd} 
EOFMUBY
)\""
        end
		return cmd
    end

	def output_command cmd
        if !@print_only
            self.execute cmd
        else
            self.print cmd
        end
    end

    def print cmd
        puts cmd
    end

    def execute cmd
        puts `#{cmd}`.chomp
    end

end

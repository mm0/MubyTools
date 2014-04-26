module Command
	attr_accessor :ENABLED
	attr_accessor :sort
	attr_accessor :state
	attr_accessor :title
	attr_accessor :print_only 
	attr_accessor :silent
	attr_accessor :verbose
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
		if can_use? == 0 || !can_use? 
			@ENABLED= false
		else 
			@ENABLED= true
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
			@input_array = self.get_input_array
		else 
			@input_array = []
		end
		if @ENABLED === true
			parsed_command = self.parse_command
			self.output_command(parsed_command)

		end
	end


	def has_inputs?
		#most commands will require inputs
		#TODO: check command input_array or have flag to indicate this
		return true;
	end

	def can_use?
	#	return true;
	end
	
	def parse_command 
		cmd = @command
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
		if @silent
			`#{cmd}`
		else
			puts `#{cmd}`.chomp
		end
    end

end

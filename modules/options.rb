require 'ostruct'
require 'optparse'

class Muby_Options_Parser
	attr_accessor :options
	@@params
	def initialize params
		@options = OpenStruct.new
		@options.library = []
		@options.inplace = false
		@options.encoding = "utf8"
		@options.transfer_type = :auto
		@options.verbose = false
    @options. banner = "Muby Command Line Tool Menu"
		#@options = {}#OpenStruct.new
		@@params = params
		@version = "Muby Tools Version: 0.1"
		self.start
	end


	def start
		#TODO: Code completion 
		#
#puts String.color_matrix
		OptionParser.new do |opts|
			opts.banner = @options.banner + "\n\t" + "Usage ruby muby.rb [options]"+"\n"

			opts.separator ""
			opts.separator "Common options:"
			#custom parameter binding for commands
			@@params.each { |custom_param|
				opts.on("--#{custom_param['string']}=INPUT","#{custom_param['description']}") do |v|
					string = custom_param['string']
					@options.send("#{string}=", v)
				end
			}
			opts.on("-v", "--[no]verbose","Run verbosely") do |v|
				@options.send("verbose=", true)
			end
			opts.on("-f", "--force ","Forcefully Delete Backup") do |v|
				@options.send("force=", true)
			end
			opts.on("-p", "--print","Print command only") do |v|
				@options.send("print_only=", true)
			end
			opts.on("-s", "--silent","Run silently") do |v|
				@options.send("silent=", true)
			end
			opts.on_tail("-h", "--help", "Show this message") do
				puts opts
				exit
		  end

			  # Another typical switch to print the version.
			  opts.on_tail("--version", "Show version") do
				puts @version
				exit
			  end

		end.parse!

	end
end


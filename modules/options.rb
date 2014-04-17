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
		#@options = {}#OpenStruct.new
		@@params = params
		self.start
	end


	def start
		#TODO: Code completion 
		#
#puts String.color_matrix
		OptionParser.new do |opts|
			opts.banner = "Banner"#""Usage init.rb [options]"+"\n"+usage
			opts.on("-f", "--force ","Forcefully Delete Backup") do |v|
				@options[:force] = v
			end

			opts.separator ""
			opts.separator "Common options:"
			opts.on("-v", "--[no]verbose","Run verbosely") do |v|
				@options[:verbose] = v
			end
			@@params.each { |custom_param|
				opts.on("--#{custom_param['string']}=INPUT","#{custom_param['description']}") do |v|
					string = custom_param['string']
					@options.send("#{string}=", v)
				end
				next;
			}
			#opts.on("--directory=DIR","Print command only") do |v|
			#	@options[:directory] = v
			#end
			opts.on("-p", "--print","Print command only") do |v|
				@options[:print_only] = true
			end
			opts.on("-s", "--silent","Run silently") do |v|
				@options[:silent] = v
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

	end
end


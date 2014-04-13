require 'ostruct'
require 'optparse'
require "./muby2.rb"    


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

MUBY_APP.new(options)

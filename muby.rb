#!/usr/bin/env ruby
require_relative "muby_app"    

def clear
    print "\e[2J\e[f"
end

MUBY_APP.new

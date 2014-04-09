#!/usr/bin/ruby

module Unix
	def installed?
		require_relative '../lib/OS'
		!OS.windows?
	end
end

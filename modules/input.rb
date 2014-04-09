#!/usr/bin/ruby

module Unix
	def Unix.installed?
		require_relative '../lib/OS'
		!OS.windows?
	end
end

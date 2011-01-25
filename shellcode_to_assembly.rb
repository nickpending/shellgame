require 'shellgame.rb'

if ARGV[0].nil?
	puts "Usage: shelldump.rb \"<shellcode>\""
	exit()
end

# Filename from commandline
shellcode = ARGV[0]
shellgame = Nihil::Shellgame.new()
shellgame.shellcode_to_assembly(shellcode)
puts shellgame.assembly


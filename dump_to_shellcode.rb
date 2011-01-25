require 'shellgame.rb'

if ARGV[0].nil?
	puts "Usage: shelldump.rb <objdump output filename>"
	exit()
end

# Filename from commandline
f = File.open(ARGV[0])
s = f.readlines
shellgame = Nihil::Shellgame.new()
shellgame.dump_to_shellcode(s)
puts shellgame.shellcode.to_s


# shellgame.rb

module Nihil
  class Shellgame
    attr_reader :objdump, :shellcode, :source, :assembly
    
    # Constants
    SOURCE_FILENAME = "testgame.c"
    BINARY_FILENAME = "testgame"
    GDB_COMMANDS_INPUT = "gdb.commands"
    GDB_COMMANDS_STRING = "gdb -q -x #{GDB_COMMANDS_INPUT} #{BINARY_FILENAME}"
    GDB_COMMANDS_OUTPUT = "gdb.commands.output"
    
    def initialize()
      @shellcode = []
    end
    
    # Generates shellcode from objectdump data
    # XXX - modify cleanup to be a block we pass to do the cleanup?
    def dump_to_shellcode(objdump)
      @shellcode = extract(cleanup(objdump))
    end
    
    # Generates c source from shellcode for testing
    def shellcode_to_source(shellcode)
      @source = "
        #include <stdio.h>

        const char shellcode[] = \"#{shellcode}\";

        int
        main(int argc, char *argv[])
        {
          int (* shell)();
          shell=shellcode;
          shell();

          return 0;
        }"
    end
    
    # Displays assembly pneumonics for a piece of shellcode
    def shellcode_to_assembly(shellcode)
      shellcode_to_source(shellcode)
      # Create out source code
      write_file(SOURCE_FILENAME, @source, "w+")
      # Compile source code
      system("gcc -w -g -o #{BINARY_FILENAME} -O0 #{SOURCE_FILENAME}")
      
      gdb_commands = "set disassembly-flavor intel\nwhatis shellcode\nquit\n"
      write_file(GDB_COMMANDS_INPUT, gdb_commands, "w+")
     
      # Run gdb to pull back length of string
      system("#{GDB_COMMANDS_STRING} > #{GDB_COMMANDS_OUTPUT}")
      # Open the output of our gdb command
      f = File.open(GDB_COMMANDS_OUTPUT)
      # Extract the string length
      length = f.readlines.to_s.scan(/\d+/)
      # XXX - hack for now
      count = length.first.to_i / 2
      f.close
      
      gdb_commands = "set disassembly-flavor intel\nx/#{count}i shellcode\nquit\n"
      write_file(GDB_COMMANDS_INPUT, gdb_commands, "w+")
     
      # Execute our new gdb command string
      system("#{GDB_COMMANDS_STRING} > #{GDB_COMMANDS_OUTPUT}")
      f = File.open(GDB_COMMANDS_OUTPUT)
      @assembly = f.readlines
      f.close
    end
    
    private
    
     # Generic wrapper for opening and writing to a file
      # XXX - add exception handling
    def write_file(name, contents, flags)
      # Generate our source file
      f = File.open(name, flags)
      f.write(contents)
      f.close()
    end
      
    # Extracts the embedded shellcode from an objdump file snippet
    def extract(objdump)
      shellcode = []
      objdump.each do |line|
      	# Extract the shellcode
        m = line.match(/[:\s]+([0-9a-f]{2}+ | [0-9a-f]{2}\s)+/)
      	# Check for empty lines and other weird data in the file
      	if m.nil?
      	  next
        end
        # Remove :
        shellcode_line = m[0].gsub(/:/, '')
      	# Split on the spaces
        shellcode_line = shellcode_line.split(/ /)
      	# Iterate through each op
      	shellcode_line.each do |s|
      	  begin
      		  op = validate(s)
      		rescue => e
      		  puts e
    		  end
      		shellcode.push("\\x#{op}")
      	end
      end
      return shellcode
    end
    
    def validate(op)
      # List of invalid characters
    	invalid = %w{00 0A 0D}
    	# Remove whitespace
    	op = op.gsub(/\s*/, "")	

    	# Check for 'invalid' characters
    	invalid.each do |i|
    		# XXX - I think there is a better/safer check
    		if op == i
    			# XXX - Future code
    			# raise "Invalid characters detected." unless Option.ignore_invalid_opcodes
    			# XXX - Interim code
    			raise "warning: invalid opcode detected --> \\x#{op}"
    		end
    	end
    	return op
    end
    
    # Cleanup method
    def cleanup(objdump)
      # Remove tabs if present in the file
      objdump.collect { |line| line.gsub(/\t/, '') }
    end
  end
end


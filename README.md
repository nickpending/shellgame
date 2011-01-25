shellgame
==============
Shellcode manipulation and conversion utilities.

shellgames expect YOU to be smart about the file you want your shellcode to be generated from.
provide a file with several sections that have shellcode and this tool will happily convert
it all to shellcode although that's probably not what you want.

## Usage

Create your own utilities from shellgame:
	
	require 'nihil/shellgame'

	shellgames =  Nihil::Shellgame.new()
	
To create C source:
	
	shellgame.shellcode_to_source(shellcode)
	
To generate assembly output from shellcode:
	
	shellgame.shellcode_to_assembly(shellcode)
	
To generate shellcode from objdump output:
	
	shellgame.dump_to_shellcode(s)
	
shellgame expect YOU to be smart about the file you want your shellcode to be generated from.
Provide a file with several sections that have shellcode and this tool will happily convert
it all to shellcode although that's probably not what you want.

You may need to run something like this to get your objdump output:
	
	objdump -D -M intel -j .text 
	
	or
	 
	objdump -D -M intel | grep -A20 .main:

## Features
* Commandline utilities for:
** Objdump to shellcode conversion
** Shellcode to C source conversion
** Shellcode to asm conversion
* Object-oriented interface (write your own utilities)

## Requirements
* gnu debugger

## History
* 01/05/2011 - Major overhaul
* 12/06/2010 - Initial release

## To Do
* Commandline UI enhancements
* Cleanup the crud left by the system()
* Section extraction from objdump

## Credits
* Rudy Ruiz -- roodee(at)thummy.com

## License
This code is free software; you can redistribute it and/or modify it under the
terms of the new BSD License. A copy of this license can be found in the
LICENSE file.


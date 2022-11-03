import os
import sanity
import parser
import commands.init

fn main() {
	command, args := parser.get_command(os.args[1..])

	if command == 'init' {
		init.start(args)
	}

	sanity.check_all_dependencies()
}

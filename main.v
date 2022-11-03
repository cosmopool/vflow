import os
import sanity
import parser
import commands.init
import git

fn main() {
	command, args := parser.get_command(os.args[1..])

	println(git.get_local_branches())
	println(git.get_remote_branches())

	if command == 'init' {
		init.start(args)
	}

	sanity.check_all_dependencies()
}

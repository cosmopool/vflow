import os
import sanity
import commands
import git

fn main() {
	println(git.get_local_branches())
	println(git.get_remote_branches())

	sanity.check_all_dependencies()
	mut init_cmd := commands.init_cmd_props()
	init_cmd.setup()
	init_cmd.parse(os.args)
}

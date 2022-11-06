import os
import sanity
import commands
import log
import cli

fn main() {
	sanity.check_all_dependencies()

	// root command
	mut cmd := cli.Command{
		name: 'oneflow'
		description: 'An example of the cli library.'
		disable_man: true
		posix_mode: true
		version: '0.0.1'
	}

	// instantiate commands
	mut init_cmd := commands.init_cmd_props()
	cmd.add_command(init_cmd)

	cmd.setup()
	cmd.parse(os.args)
}

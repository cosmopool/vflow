module init
import parser
import config
import commands { ModuleProperties }

pub fn module_props() ModuleProperties {
	return ModuleProperties{
		command: 'init'
		options: []
		flags: ['-d', '-f']
		usage: 'usage: vflow init [-fd]'
	}
}

pub fn start(args []string) {
	options, _ := parser.get_options(args)
	flags := parser.get_flags(args)
	println(options)
	println(flags)

	if is_repo_initialized() {
		
	}
}

fn is_repo_initialized() bool {
	git_config := config.get_all_config()
	return git_config.contains('oneflow')
}

fn init_config() {
	
}

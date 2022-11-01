module parser

struct ParsedArguments {
	command string
	options []string
	flags   []string
}

// Get command from argument list
fn get_command(args []string) ?(string, []string) {
	command := args[0]
	args_without_command := args[1..]
	if is_flag(command) {
		return error(command)
	} else {
		return command, args_without_command
	}
}

// Check if given [arg] is a flag
// Returns true if and only if given string starts with '-' (hyphen)
fn is_flag(arg string) bool {
	return arg[0..1] == '-'
}

// Get all options from argument list
fn get_options(args []string) ([]string, []string) {
	mut options := []string{cap: args.len}
	mut arguments := []string{cap: args.len}

	for arg in args {
		if is_flag(arg) {
			arguments << arg
		} else {
			options << arg
		}
	}

	return options, arguments
}

// Get all flags from argument list
fn get_flags(args_list []string) ?[]string {
	mut flags := []string{cap: args_list.len}

	for arg in args_list {
		if is_flag(arg) {
			flags << arg
		}
	}

	return flags
}

// Parse arguments from command line to command, options and flags
fn parse_arguments(args_list []string) ParsedArguments {
	command, options_and_args := get_command(args_list) or {
		eprintln('Invalid command given: $err')
		eprintln('Use "--help" to see available commands')
		exit(1)
	}
	options, args := get_options(options_and_args)
	flags := get_flags(args) or {
		eprintln('Invalid argument passed: $err')
		exit(1)
	}

	return ParsedArguments{
		command: command
		options: options
		flags: flags
	}
}

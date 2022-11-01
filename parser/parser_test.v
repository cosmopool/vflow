module parser
import os

// Parser should separate commands and options from args
fn test_should_parse_arguments() {
  arguments_from_command_line := ['first_command', 'argument1', 'argument2']
  result, args := get_command(arguments_from_command_line) or {return}
  assert result == 'first_command'
  assert args == ['argument1', 'argument2']
}

// Parser should separate commands and options from args
fn test_get_command_with_no_command() {
  arguments_from_command_line := ['-d', '--flag', 'option', 'command']
  result, _ := get_command(arguments_from_command_line) or { 
    '$err', []string{}
  }
  assert result == '-d'
}

// Returns true if the program can be successfully executed
// with a `--help` flag.
fn test_cmd_exists() {
	result := os.execute('v run main.v --help')
	assert result.exit_code == 0
}

// Returns true if given argument is flag
// returns false for all non flag argument
fn test_is_flag() {
  flags := ['-d', '-df', '--help', '--version', '-asdfo']
	for flag in flags {
	  assert is_flag(flag) == true
	}

  non_flag := ['hip-no', 'text', 'int--', 's-t-r-i-n-g']
	for non_flag_arg in non_flag {
	  assert is_flag(non_flag_arg) == false
	}
}

// Should return an array with 3 strings
fn test_get_options_with_3_options_given() {
  args := ['option1', 'option2', 'option3', '--version', '-asdfo']
	options, flags := get_options(args)
	assert options == ['option1', 'option2', 'option3']
	assert flags == ['--version', '-asdfo']
}

// Should return an empty array
fn test_get_options_with_no_options_given() {
  args := ['--version', '-asdfo']
	options, flags := get_options(args)
	assert options == []
  assert flags == ['--version', '-asdfo']
}

// Parser should separate commands and options from args
fn test_parse_arguments() {
  arguments_from_command_line := ['command', 'option1', 'option2', '-d', '-f', '--flag', '--flag2']
  parsed_arguments := parse_arguments(arguments_from_command_line)
  assert parsed_arguments.command == 'command'
  assert parsed_arguments.options == ['option1', 'option2']
  assert parsed_arguments.flags == ['-d', '-f', '--flag', '--flag2']
}

// Execute the program with '--help' command should show
// 'init' section
fn test_help_command_show_init() {
	result := os.execute('v run main.v --help')
	assert result.output.contains('init'), 'Help output command should contains "init" section keyword'
}

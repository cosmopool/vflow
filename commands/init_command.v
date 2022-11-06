module commands

import cli { Command, Flag, FlagType }
import config
import git

pub fn init_cmd_props() &Command {
	force := Flag{
		flag: FlagType.bool
		name: 'force'
		abbrev: 'f'
		description: 'Force reinitialization of oneflow repo, even if already configured'
	}

	defaults := Flag{
		flag: FlagType.bool
		name: 'defaults'
		abbrev: 'd'
		description: 'Use default branch naming conventions'
	}

	mut cmd := Command{
		name: 'init'
		usage: 'oneflow init [-fd]'
		description: 'Initialize a new repo with support for the oneflow model'
		disable_man: true
		disable_version: true
		posix_mode: true
		flags: [force, defaults]
		execute: execute_init
	}
	return &cmd
}

fn execute_init(cmd Command) ! {
	is_valid_git_repo := git.git_is_valid_repo()
	if !is_valid_git_repo {
		_ := git.git_do('init')
	} else {
		// is_not_headless := git.is_not_headless_repo()
		git.require_clean_working_tree()
	}

	if is_repo_initialized() {
		init_config()
	}
}

fn is_repo_initialized() bool {
	is_valid_git_repo := git.git_is_valid_repo()
	if is_valid_git_repo {
		git_config := config.get_all_config()
		return git_config.contains('oneflow')
	} else {
		return false
	}
}

fn init_config() {
}

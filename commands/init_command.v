module commands

import cli { Command, Flag, FlagType }
import config
import git
import readline { read_line }

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
		// TODO: check if repo is headless
		// is_not_headless := git.is_not_headless_repo()
		// git.require_clean_working_tree()
	}

	force_flag := cmd.flags.get_bool('force')!

	// check if already initialized repo. print
	if is_repo_already_initialized() && !force_flag {
		println('Already initialized for oneflow.')
		println('To force reinitialization, use: oneflow init -f')
		exit(0)
	}

	defaults_flag := cmd.flags.get_bool('defaults')!

	setup_branch_main(defaults_flag)
	setup_branch_feature(defaults_flag)
	setup_branch_release(defaults_flag)
	setup_branch_hotfix(defaults_flag)
	setup_branch_support(defaults_flag)
	setup_tag_version(defaults_flag)
	// setup_github_feature(defaults_flag)
}

// is_repo_already_initialized check if current repo is already initialized for oneflow.
// returns true if repo is initialized
// returns false if `force_flag` is true.
fn is_repo_already_initialized() bool {
	git_config := config.get_all_config()
	return git_config.contains('oneflow')
}

// setup_branch_config set git config in given `config_path`
// uses `default_suggestion` when `defaults` is true
// read command line for value if `defaults` is false
fn setup_branch_config(prompt string, config_path string, default_suggestion string, defaults bool) {
	if defaults {
		git.set_oneflow_config(config_path, default_suggestion)
	} else {
		mut prefix := read_line(prompt) or { exit(1) }

		if prefix == '\n' {
			prefix = default_suggestion
		}

		git.set_oneflow_config(config_path, prefix)
	}
}

fn setup_branch_main() {
	git.has_oneflow_main_configured()

	config_path := 'prefix.main'
	default_suggestion := 'main'
	prompt := 'Main branch? [{default_suggestion}]: '
	setup_branch_config(prompt, config_path, default_suggestion, defaults_flag)
}

// setup_branch_feature set a prefix for all feature branches
fn setup_branch_feature(defaults_flag bool) {
	config_path := 'prefix.feature'
	default_suggestion := 'feature/'
	prompt := 'Feature branches? [{default_suggestion}]: '
	setup_branch_config(prompt, config_path, default_suggestion, defaults_flag)
}

// setup_branch_release set a prefix for all release branches
fn setup_branch_release(defaults_flag bool) {
	config_path := 'prefix.release'
	default_suggestion := 'release/'
	prompt := 'Release branches? [{default_suggestion}]: '
	setup_branch_config(prompt, config_path, default_suggestion, defaults_flag)
}

// setup_branch_hotfix set a prefix for all hotfix branches
fn setup_branch_hotfix(defaults_flag bool) {
	config_path := 'prefix.hotfix'
	default_suggestion := 'hotfix/'
	prompt := 'Hotfix branches? [{default_suggestion}]: '
	setup_branch_config(prompt, config_path, default_suggestion, defaults_flag)
}

// setup_branch_support set a prefix for all support branches
fn setup_branch_support(defaults_flag bool) {
	config_path := 'prefix.support'
	default_suggestion := 'support/'
	prompt := 'Support branches? [{default_suggestion}]: '
	setup_branch_config(prompt, config_path, default_suggestion, defaults_flag)
}

// setup_tag_version set a prefix for all tags
fn setup_tag_version(defaults_flag bool) {
	config_path := 'prefix.versiontag'
	default_suggestion := ''
	prompt := 'Version tag prefix? [{default_suggestion}]: '
	setup_branch_config(prompt, config_path, default_suggestion, defaults_flag)
}

// fn setup_github_feature(defaults_flag bool) {
// 	config_path := 'github.pullrequest'
// 	default_suggestion := 'no'
// 	prompt := 'Want to use GitHub command line pull request feature? [{default_suggestion}]: '
// 	setup_branch_config(prompt, config_path, default_suggestion, defaults_flag)
//
// 	github_pullrequest := git.get_oneflow_config(config_path)
// 	need_to_login := github_pullrequest == 'yes'
// 	println('github_pullrequest: {github_pullrequest}')
// 	println('need_to_login: {need_to_login}')
// 	if need_to_login {
// 		println('To finish the configuration, login with your GitHub account.')
// 		println('You will now be using GitHub "gh" software...')
// 		println('')
// 		os.execute('gh auth login')
// 	}
// }

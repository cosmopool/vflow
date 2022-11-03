module git

import os

pub fn is_not_headless_repo() bool {
	result := os.execute('git rev-parse --abbrev-ref --symbolic-full-name HEAD')
	return result.output != 'HEAD'
}

pub fn is_clean_working_tree() bool {
	result := os.execute('git diff --no-ext-diff --ignore-submodules --quiet --exit-code')
	return result.exit_code == 0
}

pub fn git_local_branches() []string {
	result := os.execute("git branch --no-color | sed 's/^[* ] //'")
	return result.output
}

pub fn git_remote_branches() []string {
	result := os.execute("git branch -r --no-color | sed 's/^[* ] //'")
	return result.output
}

pub fn git_all_branches() []string {
	local := git_local_branches()
	remote := git_remote_branches()

	mut result := []string{cap: local.len + remote.len}
	result << local
	result << remote

	return result
}

pub fn git_all_tags() []string {
	result := os.execute('git tags')
	return result.output
}
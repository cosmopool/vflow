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

pub fn get_local_branches() []string {
	result := os.execute("git branch --no-color | sed 's/^[* ] //'")
	return result.output.split_any('\n')
}

pub fn get_remote_branches() []string {
	result := os.execute("git branch -r --no-color | sed 's/^[* ] //'")
	return result.output.split_any('\n')
}

pub fn get_all_branches() []string {
	local := get_local_branches()
	remote := get_remote_branches()

	mut result := []string{cap: local.len + remote.len}
	result << local
	result << remote

	return result
}

pub fn get_all_tags() []string {
	result := os.execute('git tags')
	return result.output.split_any('\n')
}

pub fn get_current_branch() string {
	result := os.execute('git rev-parse --abbrev-ref HEAD')
	return result.output
}

pub fn local_branch_exists(branch string) bool {
	branches := get_local_branches()
	return branch in branches
}

pub fn remote_branch_exists(branch string) bool {
	branches := get_remote_branches()
	return branch in branches
}

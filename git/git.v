module git

import os

fn execute(command string) (string, int) {
	result := os.execute(command)
	return result.output, result.exit_code
}

pub fn is_not_headless_repo() bool {
	output, _ := execute('git rev-parse --abbrev-ref --symbolic-full-name HEAD')
	return output != 'HEAD'
}

pub fn is_clean_working_tree() int {
	unstaged_check := os.execute('git diff --no-ext-diff --ignore-submodules --quiet --exit-code').exit_code
	if unstaged_check != 0 {
		return 1
	}

	uncommited_check := os.execute('git diff-index --cached --quiet --ignore-submodules HEAD --').exit_code
	if uncommited_check != 0 {
		return 2
	}

	return 0
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

pub fn branch_exists(branch string) bool {
	branches := get_all_branches()
	return branch in branches
}

pub fn tag_exists(tag string) bool {
	tags := get_all_tags()
	return tag in tags
}

//
// git_compare_branches()
//
// Tests whether branches and their "origin" counterparts have diverged and need
// merging first. It returns error codes to provide more detail, like so:
//
// 0    Branch heads point to the same commit
// 1    First given branch needs fast-forwarding
// 2    Second given branch needs fast-forwarding
// 3    Branch needs a real merge
// 4    There is no merge base, i.e. the branches have no common ancestors
//
pub fn compare_branches(first_branch string, second_branch string) int {
	commit1 := os.execute('git ref-parse $first_branch').output
	commit2 := os.execute('git ref-parse $second_branch').output

	if commit1 != commit2 {
		result_merge := os.execute('git merge-base $commit1 $commit2')
		base := result_merge.output
		merge_exit_code := result_merge.exit_code

		if merge_exit_code != 0 {
			return 4
		} else if commit1 == base {
			return 1
		} else if commit2 == base {
			return 2
		} else {
			return 3
		}
	} else {
		return 0
	}
}

//
// git_is_branch_merged_into()
//
// Checks whether branch $1 is succesfully merged into $2
//
pub fn git_is_branch_merged_into(subject string, base string) bool {
	all_merges := os.execute("git branch --no-color --contains $subject | sed 's/^[* ] //'").output
	return base.contains(all_merges)
}

//
// git_is_repo_init()
//
// Checks whether current dir is a valid git repository
//
pub fn git_is_valid_repo() bool {
	exit_code := os.execute('git rev-parse --git-dir >/dev/null 2>&1').exit_code
	return exit_code == 0
}

//
// git_do(command string)
//
// Executes a git command
//
pub fn git_do(command string) os.Result {
	result := os.execute('git {command}')
	return result
}

pub fn require_clean_working_tree() {
	code := is_clean_working_tree()
	if code == 1 {
		println('Working tree contains unstaged changes. Aborting...')
		exit(1)
	} else if code == 2 {
		println('Index contains uncommited changes. Aborting...')
		exit(1)
	}
}

pub fn get_oneflow_config(config string) string {
	result := os.execute('git config --get oneflow.{config}')
	return result.output
}

pub fn set_oneflow_config(config string, value string) bool {
	result := os.execute('git config oneflow.{config} "{value}"')
	return result.exit_code == 0
}

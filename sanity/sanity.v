module sanity

import os
import config

fn check_dependency(dependency string) bool {
	result := os.execute('ls /usr/bin/$dependency')
	return result.exit_code == 0
}

fn get_dependency_list() []string {
	mut dependency_list := ['git', 'sed']
	git_config := config.get_all_config()
	depends_on_gh := git_config.contains('gitflow.github.pullrequest=yes')

	if depends_on_gh {
		dependency_list << 'gh'
	}

	return dependency_list
}

pub fn check_all_dependencies() {
	dependency_list := get_dependency_list()

	for dep in dependency_list {
		is_dep_installed := check_dependency(dep)
		if is_dep_installed == false {
			eprintln('Could not find "$dep" command.')
			eprintln('Make sure to install and try again!')
			exit(1)
		}
	}
}

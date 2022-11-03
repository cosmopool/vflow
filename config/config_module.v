module config

import os

pub fn get_all_config() string {
	result := os.execute('git config --list')
	return result.output
}

pub fn set_config(config string, value string) bool {
	result := os.execute('git config $config=$value')
	return result.exit_code == 0
}

pub fn unset_config(config string) bool {
	result := os.execute('git config --unset $config')
	return result.exit_code == 0
}

# bats test file
# https://github.com/sstephenson/bats

load "${BATS_TEST_DIRNAME}/../includes/read_config_file"

@test "Check for 'tests/configs' directory" {
	run stat ${BATS_TEST_DIRNAME}/configs
	[ $status = 0 ]
}

@test "nonexistent configuration file" {
    source "${BATS_TEST_DIRNAME}/../includes/globals"
    source "${BATS_TEST_DIRNAME}/../includes/config_error" 
    read_config_file ${BATS_TEST_DIRNAME}/configs/nonexistent_file.conf
    result=${lines[-1]}
    substring="Did not find config file"
    [ "${result#*$substring}" != "$result" ]
}

@test "config variable backup_base gets trimmed" {
    source "${BATS_TEST_DIRNAME}/../includes/globals"
    source "${BATS_TEST_DIRNAME}/../includes/config_error" 
    read_config_file ${BATS_TEST_DIRNAME}/configs/read_config_file_trims_and_variables.conf
    result=${Configuration[backup_base]}
    [ "$result" == "/etc" ]
}
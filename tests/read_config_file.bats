# bats test file
# https://github.com/sstephenson/bats

source "${BATS_TEST_DIRNAME}/../includes/read_config_file" >/dev/null 2>/dev/null

@test "Check for 'tests/configs' directory" {
	run stat ${BATS_TEST_DIRNAME}/configs
	[ $status = 0 ]
}

@test "backup_base set to /etc" {
    source "${BATS_TEST_DIRNAME}/../includes/globals" >/dev/null 2>/dev/null
    source "${BATS_TEST_DIRNAME}/../includes/config_error" >/dev/null 2>/dev/null
    read_config_file ${BATS_TEST_DIRNAME}/configs/backup_base_set_to_etc.conf
    result=${Configuration[backup_base]}
    [ "$result" == "/etc" ]
}
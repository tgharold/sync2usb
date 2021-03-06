#!/bin/bash

# exit immediately on errors
set -e
# error out if uninitialized variable is used
set -u

# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SCRIPTDIR="${SCRIPTDIR}/includes"
source "${SCRIPTDIR}/globals"

# Configuration Variables:
#
# GLOBAL / USER:
#
# job_dir - location of job files
# lvm_snapshotadd - Amount (in GiB) to add to the LV when doing the snapshot
# lvm_thinflag - (possibly not needed), 'true' if LV is a "thin" LV
# lvm_vgname - Volume Group name which contains the LV (optional)
# minimum_free_space - Measured in GiB (gigabytes), error if target has less, warn at 2x or less
# minimum_free_inodes - Error if target file system has less, warn at 2x or less
# usb_base - directory where USB backup drives are mounted
# usb_prefix - space delimited list of letters/numbers used as prefixes
# usb_filename - the unchanging portion of the mount directory
# usb_suffix - space delimited list of letters/numbers used as suffixes
# verbosity - 0=none, 1=some info, 2=debug level
#
# JOB SPECIFIC:
#
# backup_base - Location of the directory to be backed up
# backup_dir - A directory inside the backup_base location
# lvm_lvname - Logical Volume name of the backup_base directory (optional)
# usb_dir - Directory name to use on USB drive (defaults to backup_dir)

source "${SCRIPTDIR}/config_error"
source "${SCRIPTDIR}/list_variables"
source "${SCRIPTDIR}/push_config_variables"
source "${SCRIPTDIR}/pop_config_variables"
source "${SCRIPTDIR}/trim"
source "${SCRIPTDIR}/read_config_file"
source "${SCRIPTDIR}/shuffles"
source "${SCRIPTDIR}/find_JobFiles"

list_variables "Default Variables:"

read_config_file ${GlobalConfigFilename}
list_variables "Variables after ${GlobalConfigFilename}"
read_config_file ${UserConfigFilename}
list_variables "Variables after ${UserConfigFilename}"
read_config_file ${LocalConfigFilename}
list_variables "Variables after ${LocalConfigFilename}"

find_JobFiles
shuffle_JobFiles

push_config_variables
pop_config_variables

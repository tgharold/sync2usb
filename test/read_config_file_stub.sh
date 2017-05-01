#!/bin/bash

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SCRIPTDIR="${SCRIPTDIR}/../includes"
source "${SCRIPTDIR}/globals"
source "${SCRIPTDIR}/config_error"
source "${SCRIPTDIR}/read_config_file"

read_config_file "$1"

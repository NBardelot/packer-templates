#!/bin/bash

set -e
set -o pipefail

PROJECT_DIR="$(dirname "$0")/.."

usage() {
	>&2 printf "[INFO] Usage: $0 <kickstart installer file>\n"
	>&2 printf "[INFO] Available installers:\n"
	find "$PROJECT_DIR/installers" -name "*.cfg" | >&2 xargs printf "$0 %s\n"
	exit 0
}

log_and_die() {
	>&2 printf "$1"
	exit 1	
}

log_usage_and_die() {
	>&2 printf "$1"
	usage
	exit 1
}

KSVALIDATOR_PATH=$(which ksvalidator 2>&1 1>/dev/null)
KSVALIDATOR_EXISTS=$?
[ "$KSVALIDATOR_EXISTS" -ne 0 ] && log_and_die "[FATAL] ksvalidator binary not found...\n"
[ "$#" -lt 1 ] && log_usage_and_die
KICKSTART_INSTALLER_FILE="$1"
[ ! -f "$KICKSTART_INSTALLER_FILE" ] && log_and_die "[FATAL] Kickstart installer file not found: ${KICKSTART_INSTALLER_FILE}\n"

>&2 printf "[INFO] ksvalidator validation for ${KICKSTART_INSTALLER_FILE}\n"
ksvalidator -i "${KICKSTART_INSTALLER_FILE}"

#!/bin/bash

set -e
set -o pipefail

PROJECT_DIR="$(dirname "$0")/.."

usage() {
	>&2 printf "[INFO] Usage: $0 <packer build file>\n"
	>&2 printf "[INFO] Available builds:\n"
	find "$PROJECT_DIR/builds" -name "*.json" | >&2 xargs printf "$0 %s\n"
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

PACKER_PATH=$(which packer 2>&1 1>/dev/null)
PACKER_EXISTS=$?
[ "$PACKER_EXISTS" -ne 0 ] && log_and_die "[FATAL] Packer binary not found...\n"
[ "$#" -lt 1 ] && log_usage_and_die
PACKER_BUILD_FILE="$1"
[ ! -f "$PACKER_BUILD_FILE" ] && log_and_die "[FATAL] Packer build file not found: ${PACKER_BUILD_FILE}\n"

>&2 printf "[INFO] Packer validation for ${PACKER_BUILD_FILE}\n"
packer validate "${PACKER_BUILD_FILE}"

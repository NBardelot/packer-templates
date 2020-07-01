#!/bin/bash

set -e
set -o pipefail
set -x

usage() {
	>&2 printf "[INFO] Usage: $0 <build file> <installer kind> [<installer file>]\n"
	>&2 printf "[INFO] Installer kind can be one of: unchecked, kickstart\n"	
	>&2 printf "[INFO] When the installer kind is not 'unchecked' the installer file is mandatory\n"
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

make_installer_file_from_template() {
	[ -z "$INSTALLER_FILE_TEMPLATE" ] && log_usage_and_die "[FATAL] Missing template for the installer file (mandatory for installer kind = $INSTALLER_KIND)\n"
	INSTALLER_FILE="$BUILD_DIR/installer_cache/$(basename "$INSTALLER_FILE_TEMPLATE" | sed -e 's/\.template//')"		
	envsubst < "$INSTALLER_FILE_TEMPLATE" > "$INSTALLER_FILE"
}

[ "$#" -lt 2 ] && log_usage_and_die "[FATAL] Missing arguments\n"
PROJECT_DIR="$(dirname  "$0")/.."
BUILD_FILE="$1"
BUILD_DIR="$(dirname "$1")"
INSTALLER_KIND="$2"
INSTALLER_FILE_TEMPLATE="$3" # Might be empty
mkdir -p "$BUILD_DIR/installer_cache"

# Make (and optionnaly check) the installer file
case "$INSTALLER_KIND" in
"unchecked")
	[ -n "$INSTALLER_FILE_TEMPLATE" ] && make_installer_file_from_template
	>&2 printf "[WARN] The installer file will not be validated\n"
	;;
"kickstart")
	make_installer_file_from_template
	"$PROJECT_DIR/helpers/validate_kickstart_file.sh" "$INSTALLER_FILE"
	;;
*)
	log_usage_and_die "[FATAL] Unsupported installer kind: ${INSTALLER_KIND}\n"
	;;
esac

# Check the build file
[ ! -f "$BUILD_FILE" ] && log_and_die "[FATAL] Build file not found: ${BUILD_FILE}\n"
"$PROJECT_DIR/helpers/validate_packer_build.sh" "$BUILD_FILE"

# Build the image
>&2 printf "[INFO] building ${BUILD_FILE}\n"
packer build "$BUILD_FILE"

#!/bin/bash

set -e
set -o pipefail

BUILD_FILE="CentOS-7-x86_64.json"
INSTALLER_KIND="kickstart"
INSTALLER_FILE_TEMPLATE="CentOS-7-x86_64/anaconda-ks.cfg.template"

BUILD_DIR="$(dirname $(readlink -f $0))"
PROJECT_DIR="$BUILD_DIR/../.."
source "$PROJECT_DIR/installers/$(dirname "$INSTALLER_FILE_TEMPLATE")/default_installation.conf"
[ -f "$BUILD_DIR/installation.conf" ] && source "$BUILD_DIR/installation.conf"
ln -f -s ../../provisionning-playbooks/provision.yml provision.yml # trick Packer into thinking everything is local to the build file...
"$PROJECT_DIR/helpers/.sh"
"$PROJECT_DIR/helpers/build.sh" "$BUILD_DIR/$BUILD_FILE" "$INSTALLER_KIND" "$PROJECT_DIR/installers/$INSTALLER_FILE_TEMPLATE"

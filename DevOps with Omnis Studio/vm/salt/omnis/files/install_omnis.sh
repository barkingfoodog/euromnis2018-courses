#!/usr/bin/env bash
set -e
set -u

dmg="{{ installer_file }}"
mount_point="/Volumes/omnis_application"

# Mount the disk image
hdiutil attach -mountpoint "${mount_point}" "${dmg}"

# Run the installer
installer_name=$(ls "${mount_point}" | grep .app)
"${mount_point}/${installer_name}/Contents/MacOS/installbuilder.sh" --mode unattended

# Unmount the disk image
hdiutil detach "${mount_point}"

# Remove the dmg
rm "${dmg}"
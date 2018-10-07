#!/usr/bin/env bash
set -e

SOURCE="${1}"
DESTINATION="${2}"

# Remove exiting library if exists
if [ -e "${DESTINATION}" ]; then
	rm "${DESTINATION}"
fi

# Build new library
/Applications/OmnisCI.app/Contents/MacOS/bin/omniscli import_json "${SOURCE}" "${DESTINATION}"
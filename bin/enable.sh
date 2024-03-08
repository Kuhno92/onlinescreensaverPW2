#!/bin/sh

# change to directory of this script
cd "$(dirname "$0")"

# load configuration
if [ -e "config.sh" ]; then
	source /mnt/us/extensions/onlinescreensaver/bin/config.sh
fi

# load utils
if [ -e "utils.sh" ]; then
	source  /mnt/us/extensions/onlinescreensaver/bin/utils.sh
else
	echo "Could not find utils.sh in `pwd`"
	exit
fi

if [ -e /etc/upstart ]; then
	logger "Enabling online screensaver auto-update"

	mntroot rw
	cp onlinescreensaver.conf /etc/upstart/
	mntroot ro

	start onlinescreensaver
else
	logger "Upstart folder not found, device too old"
fi

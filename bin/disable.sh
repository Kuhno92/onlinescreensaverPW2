#!/bin/sh

# change to directory of this script
cd "$(dirname "$0")"

# load configuration
if [ -e "config.sh" ]; then
	source /mnt/us/extensions/onlinescreensaver/bin/config.sh
fi

# load utils
if [ -e "utils.sh" ]; then
	source /mnt/us/extensions/onlinescreensaver/bin/utils.sh
else
	echo "Could not find utils.sh in `pwd`"
	exit
fi

# forever and ever, try to update the screensaver
logger "Disabling online screensaver auto-update"

stop onlinescreensaver || true      

mntroot rw
rm /etc/upstart/onlinescreensaver.conf
mntroot ro

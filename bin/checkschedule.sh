#!/bin/sh
#
##############################################################################
#
# Checks the format of the schedule configuration value
#
##############################################################################

# change to directory of this script
cd "$(dirname "$0")"

# load configuration
if [ -e "config.sh" ]; then
	source config.sh
fi

# load utils
if [ -e "utils.sh" ]; then
	source utils.sh
else
	echo "Could not find utils.sh in `pwd`"
	exit
fi

# get minute of day
CURRENTMINUTE=$(( `date +%-H`*60 + `date +%-M` ))

# SCHEDULE="21:00-24:00=30"
for schedule in $SCHEDULE; do
	echo "-------------------------------------------------------"
	echo "Parsing \"$schedule\""
	read STARTHOUR STARTMINUTE ENDHOUR ENDMINUTE INTERVAL << EOF
		$( echo " $schedule" | sed -e 's/[:,=,\,,-]/ /g' -e 's/\([^0-9]\)0\([[:digit:]]\)/\1\2/g' )
EOF
	echo "	Starts at $STARTHOUR hours and $STARTMINUTE minutes"
	echo "	Ends at $ENDHOUR hours and $ENDMINUTE minutes"
	echo "	Interval is $INTERVAL minutes"

	START=$(( 60*$STARTHOUR + $STARTMINUTE ))
	END=$(( 60*$ENDHOUR + $ENDMINUTE ))

	if [ $END -lt $START ]; then
		echo "!!!!!!! End time is before start time."
	fi

	if [ $CURRENTMINUTE -ge $START ] && [ $CURRENTMINUTE -lt $END ]; then
		echo "    --> This is the active setting"
	fi
done

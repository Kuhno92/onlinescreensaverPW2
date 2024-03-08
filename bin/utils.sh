##############################################################################
# Logs a message to a log file (or to console if argument is /dev/stdout)

logger () {
	MSG=$1
	
	# do nothing if logging is not enabled
	if [ "x1" != "x$LOGGING" ]; then
		return
	fi

	# if no logfile is specified, set a default
	if [ -z $LOGFILE ]; then
		$LOGFILE=stdout
	fi

	echo `date`: $MSG >> $LOGFILE
}


##############################################################################
# Retrieves the current time in seconds

currentTime () {
	date +%s
}


##############################################################################
# sets an RTC alarm
# arguments: $1 - time in seconds from now

wait_forr () { 
	# calculate the time we should return
	ENDWAIT=$(( $(currentTime) + $1 ))

	# disable/reset current alarm
	echo 0 > /sys/class/rtc/rtc$RTC/wakealarm

	# set new alarm
	echo $ENDWAIT > /sys/class/rtc/rtc$RTC/wakealarm

	# check whether we could set the alarm successfully
	if [ $ENDWAIT -eq `cat /sys/class/rtc/rtc$RTC/wakealarm` ]; then
		logger "Start waiting for timeout ($1 seconds)"

		# wait for timeout to expire
		while [ $(currentTime) -lt $ENDWAIT ]; do
			REMAININGWAITTIME=$(( $ENDWAIT - $(currentTime) ))
			if [ 0 -lt $REMAININGWAITTIME ]; then
				# wait for device to suspend or to resume - this covers the sleep period during which the
				# time counting does not work reliably
				logger "Starting to wait for timeout to expire"
				lipc-wait-event -s $REMAININGWAITTIME com.lab126.powerd resuming || true
			fi
		done

		logger "Finished waiting"
	else
       		logger "Failure setting alarm on rtc$RTC, wanted $ENDWAIT, got `cat /sys/class/rtc/rtc$RTC/wakealarm`"
	fi

	# not sure whether this is required
	lipc-set-prop com.lab126.powerd -i deferSuspend 1
}

# runs when in the readyToSuspend state;
# sets the rtc to wake up
# arguments: $1 - amount of seconds to wake up in
set_rtc_wakeup()
{
	lipc-set-prop -i com.lab126.powerd rtcWakeup $1 2>&1
	logger "rtcWakeup has been set to $1"
}

##############################################################################
# sets an RTC alarm
# arguments: $1 - time in seconds from now
wait_for () {
	ENDWAIT=$(( $(currentTime) + $1 ))
	REMAININGWAITTIME=$(( $ENDWAIT - $(currentTime) ))
	logger "Starting to wait for timeout to expire: $1"

	# wait for timeout to expire
	while [ $REMAININGWAITTIME -gt 0 ]; do
		EVENT=$(lipc-wait-event -s $1 com.lab126.powerd readyToSuspend,wakeupFromSuspend,resuming)
		REMAININGWAITTIME=$(( $ENDWAIT - $(currentTime) ))
		logger "Received event: $EVENT"

		case "$EVENT" in
			readyToSuspend*)
				set_rtc_wakeup $REMAININGWAITTIME
			;;
			wakeupFromSuspend*|resuming*)
				logger "Finishing the wait"
				break
			;;
			*)
				logger "Ignored event: $EVENT"
			;;
		esac
	done

	logger "Wait finished"
}

wait_for_fixed () {
        logger "wait_for() started"

        ### Enable CPU Powersave
        CHECKCPUMODE=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor | grep -i "powersave"`
        if [ ${CHECKCPUMODE} -eq 0 ]; then
          echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
          logger "CPU powersave mode"
        fi

        ### Disable Screensaver, no energysaving by powerd
        # powerd buggy since 5.4.5 - https://www.mobileread.com/forums/showthread.php?t=235821
        CHECKSAVER=`lipc-get-prop com.lab126.powerd status | grep -i "prevent_screen_saver:0"`
        if [ ${CHECKSAVER} -eq 0 ]; then
#          lipc-set-prop com.lab126.powerd preventScreenSaver 1
          logger "Disabled buggy energy saving"
        fi

        # calculate the time we should return
        ENDWAIT=$(( $(currentTime) + $1 )) 

        # disable/reset current wakeup alarm
        echo 0 > /sys/class/rtc/rtc$RTC/wakealarm

        # set new wakeup time
        echo $ENDWAIT > /sys/class/rtc/rtc$RTC/wakealarm

        # suspend
        logger "wait for device to resume from sleep, or for time out"
        echo "mem" > /sys/power/state
        
        logger "wait_for() finished"
}

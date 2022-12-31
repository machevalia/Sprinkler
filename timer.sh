#!/bin/bash

# Set the start and stop times in 24-hour format
START_TIME=$1
STOP_TIME=$2

# Set the current time
CURRENT_TIME=$(date +%H%M)

# Loop until the current time is between 6 AM and 12 PM
while [[ $CURRENT_TIME -lt $START_TIME || $CURRENT_TIME -ge $STOP_TIME ]]; do
  # If the current time is outside of the start and stop times, sleep for 5 minutes
  sleep 5
  # Update the current time
  CURRENT_TIME=$(date +%H%M)
done

# The script will reach this point when the current time is between 6 AM and 12 PM

# Loop through a list of integers
for i in {1..10}; do
  # Print the current integer
  echo $i
  sleep 5

  # Update the current time
  CURRENT_TIME=$(date +%H%M)

  # If the current time is outside of the start and stop times, exit the loop
  if [[ $CURRENT_TIME -lt $START_TIME || $CURRENT_TIME -ge $STOP_TIME ]]; then
          TARGET_DATE="tomorrow 06:00:00"

          # Calculate the number of seconds until the target time
          SECONDS=$(date -d "$TARGET_DATE" +%s)

        # Loop until the current time is the target time
        while [[ $(date +%s) -lt $SECONDS ]]; do
        # Sleep for 1 minute
        sleep 60
        echo "Sleeping for the next" $SECONDS "seconds"
        done
  fi

done

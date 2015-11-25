#!/bin/bash

# Wait for the number of jobs in a node to be less than a certain number. Usage
#
#    ./wait name N
#
# Checks every second that the number of subprocesses running on node name is greater than N. If this is not the case, returns.

# if timer is set to 0
if [ $2 == "0" ]; then
  exit 0;
fi

# Get all sub jobs with that name (i.e. name followed by .number)
read -a PIDS <<< $( ./list_jobs.sh )

while [ ${#PIDS[@]} -ge $2 ]; do
  sleep 1
  read -a PIDS <<< $( ./list_jobs.sh )
done

#!/bin/bash

# Wait for the number of jobs in a node to be less than a certain number. Usage:
#
#    ./wait N name
#
# Checks every 5 seconds that the number of subprocesses running on node name is
# greater than N and that the global lock is free. If this is not the case, then
# returns.

# if N is set to 0 or empty
if [ $1 == "0" ]; then
  exit 0;
fi

# get all sub jobs with that name (i.e. name followed by .number)
read -a PIDS <<< $( ${MJM_PATH}/list.sh $2 )

while [ ${#PIDS[@]} -ge $1 ]; do
  sleep 5
  read -a PIDS <<< $( ${MJM_PATH}/list.sh $2 )
done

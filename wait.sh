#!/bin/bash

# Wait for the number of jobs in a node to be less than a certain number. Usage:
#
#    ./wait name N
#
# Checks every 5 seconds that the number of subprocesses running on node name is greater than N. If this is not the case, returns.

# if N is set to 0 or empty
if [ $# -le 2 ] || [ $2 == "0" ]; then
  exit 0;
fi

# get all sub jobs with that name (i.e. name followed by .number)
read -a PIDS <<< $( ${MJM_PATH}/list.sh $1 )

while [ ${#PIDS[@]} -ge $2 ]; do
  sleep 5
  read -a PIDS <<< $( ${MJM_PATH}/list.sh )
done

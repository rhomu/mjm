#!/bin/bash

# Wait in the queue. Usage
#
#    mjm queue job
#
# Checks every 5 seconds that the given job is the next in the queue.

if [ -z $1 ]; then
  exit 0
fi

# get all jobs in queue order 
read -a PIDS <<< $( mjm list -p )

while [ ${PIDS[0]} != "$1" ]; do
  sleep 5
  read -a PIDS <<< $( mjm list -p )
done

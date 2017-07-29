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
read -a RPIDS <<< $( mjm list -rp )
read -a QPIDS <<< $( mjm list -qp )

# check that 
#   * total number of running jobs is smaller than MJM_MAX
#   * the job $1 is next in the queue
while [[ "${#RPIDS[@]}" -ge "$MJM_MAX" ||  ${QPIDS[0]} != $1 ]]
do
  sleep 5
  read -a RPIDS <<< $( mjm list -rp )
  read -a QPIDS <<< $( mjm list -qp )
done

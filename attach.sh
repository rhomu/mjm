#!/bin/bash

# Attach to a running session. Usage:
#
#    mjm attach name
#

# get all jobs that match
read -a JOBS <<< $( mjm list $1 )

if [ ${#JOBS[@]} -ne 1 ]; then
  echo "Name does not an unique terminal node. Can not attach."
  exit 1
fi

# attach
screen -r ${JOBS[0]}

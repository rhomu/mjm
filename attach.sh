#!/bin/bash

# Attach to a running session. Usage:
#
#    mjm attach job
#

# get full PID directly from screen
read -a PIDS <<< $(screen -ls | awk "/${1}.*\t/ {print \$1}")

if [ ${#PIDS[@]} -ne 1 ]; then
  echo "Name does not an unique terminal node. Can not attach."
  exit 1
fi

# attach
screen -r ${PIDS[0]}

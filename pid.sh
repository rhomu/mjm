#!/bin/bash

# Get full PID of given jobs. Usage:
#
#    mjm pid job1 job2 ...
#

PIDS=""

for i in "$@"
do
  PID=$( screen -ls | awk "/${i}.*\t/ {print \$1}" )

  if [ -z $PID ]; then
    echo "Can not get PID for job '$i'."
    exit 1
  fi

  PIDS="${PIDS[@]}$PID "
done

echo "${PIDS[@]}"

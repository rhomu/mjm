#!/bin/bash

PIDS=""

for i in "$@"
do
  PID=$( screen -ls | awk "/${i}.*\t/ {print \$1}" )

  PIDS="${PIDS[@]}$PID "
done

echo "${PIDS[@]}"

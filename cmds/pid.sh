#!/bin/bash

PIDS=""

for i in "$@"
do
  STAMPS=($(ls -cr $MJM_QUEUE_PATH/**/$i.pid 2> /dev/null))

  for j in "${STAMPS[@]}"
  do
    PID=$( cat $j )
    PIDS="${PIDS[@]}$PID "
  done
done

if ! [ -z ${PIDS} ]
then
  echo "${PIDS[@]}"
fi

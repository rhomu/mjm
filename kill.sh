#!/bin/bash

# All jobs in a node. Usage:
#
#    ./kill.sh name
#

# get all sub jobs with that name (i.e. name followed by .number)
read -a PIDS <<< $( ${MJM_PATH}/list.sh $1 )

# quit all sesssions
for i in "${PIDS[@]}"; do
  screen -X -S $i kill
done

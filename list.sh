#!/bin/bash

# List jobs belonging to a certain node. Usage
#
#    mjm list name
#

# get name
if [ -z $1 ] ; then
  NAME="$1"
else
  NAME=".$1"
fi

# get all sub jobs with that name (i.e. name followed by .number)
read -a PIDS <<< $(screen -ls | awk "/mjm${NAME}.*\t/ {print \$1}")

# print it
echo "${PIDS[*]}"

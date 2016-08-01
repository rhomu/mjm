#!/bin/bash

# List jobs belonging to a certain node. Usage
#
#    ./list_jobs name
#

# Get all sub jobs with that name (i.e. name followed by .number)
read -a PIDS <<< $(screen -ls | awk "/mjm\.$1.*\t/ {print \$1}")

# print it
echo "${PIDS[*]}"

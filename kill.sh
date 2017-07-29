#!/bin/bash

# Kill jobs. Usage:
#
#    mjm kill job1 job2 ...
#

# get all pids
read -a PIDS <<< $( mjm pid $@ )

# quit all sesssions
for i in "${PIDS[@]}"; do
  screen -X -S $i kill
done

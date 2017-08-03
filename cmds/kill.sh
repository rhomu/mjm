#!/bin/bash

# get all pids
read -a PIDS <<< $( mjm pid $@ )

# quit all sesssions
for i in "${PIDS[@]}"; do
  screen -X -S $i kill
done

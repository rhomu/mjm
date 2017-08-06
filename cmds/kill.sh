#!/bin/bash

# get all pids
read -r -a PIDS <<< "$( mjm pid "$@" )"

# quit all sesssions
for i in "${PIDS[@]}"; do
  screen -X -S "$i" kill
done

#!/bin/bash

# get all pids
read -r -a PIDS <<< "$( mjm pid "$@" )"

# quit all sessions
for i in "${PIDS[@]}"; do
  echo "killing job $i"
  screen -X -S "$i" kill
done

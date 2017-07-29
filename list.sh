#!/bin/bash

# List all jobs in correct queue order. Usage
#
#    mjm list
#
# Options: 
#   -p       Prints only PIDS (for internal use)

PRINT=true
while getopts "p" opt; do
  case $opt in
    p)
      PRINT=false
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

PIDS=""

# get pids (and print) for a certain priority
function get_pids
{
  read -a GETPIDS <<< $( ls -c $MJM_QUEUE_PATH/$1 )
  PIDS="$PIDS $GETPIDS"

  if [ $PRINT == true ]
  then
    for i in "${GETPIDS[@]}"
    do
      read -r CMD <<< $( sed '1q;d' $MJM_QUEUE_PATH/$1/$i )
      STA=$( sed '2q;d' $MJM_QUEUE_PATH/$1/$i )
      printf " %-19s %-20s %-20s %s\n" "$i" "very-high" "$STA" "$CMD"
    done
  fi
}

if [ $PRINT == true ]
then
  printf "%-20s %-20s %-20s\n" "Id" "Priority" "Status"
  echo "------------------------------------------------"
fi

get_pids "very-high"
get_pids "high"
get_pids "normal"
get_pids "low"
get_pids "very-low"

# get all sub jobs with that name (i.e. name followed by .number)
# read -a PIDS <<< $(screen -ls | awk "/mjm${NAME}.*\t/ {print \$1}")

# print it
if [ $PRINT == false ]
then
  echo "${PIDS[*]}"
fi

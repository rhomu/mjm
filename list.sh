#!/bin/bash

# List all jobs in correct queue order. Usage
#
#    mjm list
#
# Options: 
#   -p       Prints only PIDS (for internal use)
#   -r       Prints only running jobs
#   -q       Prints only queued jobs

PRINT=true
RONLY=false
QONLY=false
while getopts "prq" opt; do
  case $opt in
    p)
      PRINT=false
      ;;
    r)
      RONLY=true
      ;;
    q)
      QONLY=true
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
  read -a GETPIDS <<< $( ls -cr -I "*.status" $MJM_QUEUE_PATH/$1 )

  for i in "${GETPIDS[@]}"
  do
    CMD=$( cat $MJM_QUEUE_PATH/$1/$i )
    STA=$( cat $MJM_QUEUE_PATH/$1/$i.status )
    
    if [[ ( $RONLY == false && $QONLY == false ) ||
          ( $RONLY == true  && "$STA" == "r" ) ||
          ( $QONLY == true  && "$STA" == "q" ) ]] ;
    then
      PIDS="$PIDS $i"
      if [ $PRINT == true ]; then
        printf " %-19s %-20s %-20s %s\n" "$i" "$1" "$STA" "$CMD"
      fi
    fi
  done
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


# print only pids
if [ $PRINT == false ]
then
  echo "${PIDS[*]}"
fi

# get directly from screen (old but might be useful)
# read -a PIDS <<< $(screen -ls | awk "/mjm${NAME}.*\t/ {print \$1}")

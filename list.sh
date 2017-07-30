#!/bin/bash

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

JOBS=""

# get pids (and print) for a certain priority
function get_pids
{
  read -a STAMPS <<< $( ls -cr -I "*.status" $MJM_QUEUE_PATH/$1 )

  for i in "${STAMPS[@]}"
  do
    CMD=$( cat $MJM_QUEUE_PATH/$1/$i )
    STA=$( cat $MJM_QUEUE_PATH/$1/$i.status )
    
    if [[ ( $RONLY == false && $QONLY == false ) ||
          ( $RONLY == true  && "$STA" == "r" ) ||
          ( $QONLY == true  && "$STA" == "q" ) ]] ;
    then
      JOBS="$JOBS $i"
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
  echo "${JOBS[*]}"
fi

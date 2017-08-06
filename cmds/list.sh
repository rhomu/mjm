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

# get job names (and print) for a certain priority
function get_jobs
{
  mapfile -t STAMPS < <(ls -cr -I "*.status" -I "*.cmd" -I "*.pid" "$MJM_QUEUE_PATH/$1/")

  for i in "${STAMPS[@]}"
  do
    CMD=$( cat "$MJM_QUEUE_PATH"/"$1"/"$i".cmd )
    STA=$( cat "$MJM_QUEUE_PATH"/"$1"/"$i".status )

    if [[ ( $RONLY == false && $QONLY == false ) ||
          ( $RONLY == true  && "$STA" == "r" ) ||
          ( $QONLY == true  && "$STA" == "q" ) ]] ;
    then
      JOBS="$JOBS$i "
      if [ $PRINT == true ]; then
        printf " %-19s %-20s %-20s %s\\n" "$i" "$1" "$STA" "$CMD"
      fi
    fi
  done
}

if [ $PRINT == true ]
then
  printf "%-20s %-20s %-20s\\n" "Id" "Priority" "Status"
  echo "------------------------------------------------"
fi

get_jobs "very-high"
get_jobs "high"
get_jobs "normal"
get_jobs "low"
get_jobs "very-low"

# print only job names
if [ $PRINT == false ]
then
  echo "${JOBS[@]}"
fi

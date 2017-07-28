#!/bin/bash

# Send job using screen. Usage:
#
#    mjm send command
#
# or
#
#    mjm send -n name command
#
# The screen session is killed after the command returns. EXPLAIN THE NODE STORY. The actual screen session name is
#
#    mjm.name.i
#
# where i is the smallest job number available (starting from 0). If no name is provided then .name is omited.

# get job name from options
NAME=""
PRIORITY="normal"
while getopts ":n:p:" opt; do
  case $opt in
    n)
      NAME=".$OPTARG" >&2
      ;;
    p)
      PRIORITY="$OPTARG" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# check priority
if [ "$PRIORITY" == "very-low" ]
then
  :
elif [ "$PRIORITY" == "low" ]
then
  :
elif [ "$PRIORITY" == "normal" ]
then
  :
elif [ "$PRIORITY" == "high" ]
then
  :
elif [ "$PRIORITY" == "very-high" ]
then
  :
else
  echo "Unknown priority '$PRIORITY' (should be very-low, low, normal, high, very-high)"
  exit 1
fi
 
# lock
mjm lock

# construct job name...
# ...get all numbers of sub-jobs (i.e. name followed by .number)
read -a PIDS <<< $( screen -ls \
                    | awk "/mjm${NAME}[.0-9]*\t/ {print \$1}" \
                    | sed "s/.*\.//g"
                  )
# ...find smallest number not in this list
for (( i=0 ;; ++i )); do
  if ! echo " ${PIDS[*]} " | grep " $i " -q ; then
    # ...and add it to jobname
    JNAME="mjm${NAME}.$i"
    break
  fi
done

# get the command...
if [ -z ${NAME} ] ; then
  CMD="${@}"
else
  CMD="${@:3}"
fi
# ...check that CMD is not empty
if [[ -z "${CMD// }" ]]; then
  echo "Discarding empty command."
  exit 1
fi
# ...and get timestamp
TS=$(date +%s)
# ...and log file name
LNAME=${JNAME}.${TS}.out

# send job...
echo "Sending job ${JNAME} to ${LNAME} ... "
# ...create session
screen -dmS "$JNAME" ; sleep 0.5
# ...escape points in job name
JNAME_ESCAPE=$(echo "$JNAME" | sed 's/\./\\\./g')
# ...get PID back (there are sometimes conflicts)
PID=$(screen -ls | awk "/\.${JNAME_ESCAPE}\t/ {print strtonum(\$1)}")
# ...name of the queue file for the job
QUEUE_FILE=$MJM_QUEUE_PATH/$PRIORITY/$PID.$JNAME
# ...write queue file
touch $QUEUE_FILE
# ...send the command to the screen session
screen -S "$PID.$JNAME" -p 0 -X stuff "${MJM_PATH}/wait.sh ${MJM_NMAX} ; ( ( ${MJM_PATH}/header.sh ; ${CMD} ) | tee ${LNAME} ) ; rm $QUEUE_FILE -f ; exit$(printf \\r)"

# unlock
mjm unlock
# ...wait a bit
sleep 0.3

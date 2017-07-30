#!/bin/bash

# get job name from options
NAME=""
PRIORITY="normal"
OPT_SHIFT="1"
while getopts ":n:p:" opt; do
  case $opt in
    n)
      NAME=".$OPTARG" >&2
      OPT_SHIFT=$(($OPT_SHIFT + 2))
      ;;
    p)
      PRIORITY="$OPTARG" >&2
      OPT_SHIFT=$(($OPT_SHIFT + 2))
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

# get the command...
CMD="${@:$OPT_SHIFT}"
# ...check that CMD is not empty
if [[ -z "${CMD// }" ]]; then
  echo "Discarding empty command."
  exit 1
fi

# construct job name...
# ...get all numbers of sub-jobs (i.e. name followed by .number)
JOBS=$( mjm list -p )
# ...find smallest number not in this list
for (( i=0 ;; ++i )); do
  if ! ( echo ${JOBS[@]} | grep $i -q ); then
    # ...and add it to jobname
    JNAME="mjm${NAME}.$i"
    break
  fi
done
# ...and get timestamp
TS=$(date +%s)
# ...and log file name
LNAME=${TS}.${JNAME}.out

# send job...
echo "Sending job ${JNAME} to ${LNAME} ... "
# ...create session
screen -dmS "$JNAME" ; sleep 0.5
# ...escape points in job name
JNAME_ESCAPE=$(echo "$JNAME" | sed 's/\./\\\./g')
# ...get PID back (there are sometimes conflicts)
PID=$(screen -ls | awk "/\.${JNAME_ESCAPE}\t/ {print strtonum(\$1)}")
# ...name of the queue file for the job
QUEUE_FILE=$MJM_QUEUE_PATH/$PRIORITY/$JNAME
# ...write queue file
echo \"${CMD}\" > $QUEUE_FILE
echo "q" > ${QUEUE_FILE}.status
# ...produce screen command
SCREEN_CMD=":"
SCREEN_CMD="$SCREEN_CMD ; trap 'rm -f $QUEUE_FILE ${QUEUE_FILE}.status ; exit 1' EXIT TERM INT" # trap queue file deletion
SCREEN_CMD="$SCREEN_CMD ; mjm queue $JNAME" # wait for other jobs to finish
SCREEN_CMD="$SCREEN_CMD ; echo \"r\" > ${QUEUE_FILE}.status" # set queue file status to r (running)
SCREEN_CMD="$SCREEN_CMD ; ( ( mjm header ; ${CMD} ) | tee ${LNAME} )" # the actual cmd + log
# ...send the command to the screen session
screen -S "$PID.$JNAME" -p 0 -X stuff "$SCREEN_CMD ; exit$(printf \\r)"

# unlock
mjm unlock
# ...wait a bit
sleep 0.3

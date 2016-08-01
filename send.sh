#!/bin/bash

# Send job using screen. Usage:
#
#    ./send_job name command
#
# The screen session is killed after the command returns. EXPLAIN THE NODE STORY. The actual screen session name is
#
#    mjm.name.i
#
# where i is the smallest job number aviable (starting from 0).

# TBI
#  * priority/queue
#  * logging, using tee

# construct job name...
# ...get all numbers of sub-jobs (i.e. name followed by .number)
read -a PIDS <<< $( screen -ls \
                    | awk "/mjm\.$1[.0-9]*\t/ {print \$1}" \
                    | sed "s/.*\.//g"
                    )
# ...find smallest number not in this list
for (( i=0 ;; ++i )); do
  if ! echo " ${PIDS[*]} " | grep " $i " -q ; then
    # ...and add it to jobname
    JNAME="mjm.$1.$i"
    break
  fi
done

# send job...
echo "Sending job $JNAME ... "
# ...create session
screen -dmS "$JNAME" ; sleep 0.5
# ...escape points in job name
JNAME_ESCAPE=$(echo "$JNAME" | sed 's/\./\\\./g')
# ...get PID back (there are sometimes conflicts)
PID=$(screen -ls | awk "/\.${JNAME_ESCAPE}\t/ {print strtonum(\$1)}")
# ...send the command to the screen session
screen -S "$PID.$JNAME" -p 0 -X stuff "$2 ; exit$(printf \\r)"
# ...wait a bit
sleep 0.3

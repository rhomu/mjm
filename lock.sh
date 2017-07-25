#!/bin/bash

# Lock all wait queries. Usage
#
#    mjm lock
#
# If lock is present, wait until unlocked.

echo ${MJM_LOCK_PATH}

# wait for unlock
while [ -f ${MJM_LOCK_PATH} ]; do
  echo "Lock found at ${MJM_LOCK_PATH}, waiting 1 sec."
  sleep 1
done

# lock
touch ${MJM_LOCK_PATH}

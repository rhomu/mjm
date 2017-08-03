#!/bin/bash

# wait for unlock
until ( set -o noclobber ; echo "$$" > "${MJM_LOCK_PATH}" ) 2> /dev/null ; do
  echo "Lock found at ${MJM_LOCK_PATH}, waiting 1 sec."
  sleep 1
done

# trap to avoid race conditions
trap 'rm -f "${MJM_LOCK_PATH}"; exit $?' INT TERM

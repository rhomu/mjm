#!/bin/bash

if [ $# -eq 0 ]
then
  WC="*"
else
  WC="$1*"
fi

rm -f $MJM_QUEUE_PATH/very-high/$WC
rm -f $MJM_QUEUE_PATH/high/$WC
rm -f $MJM_QUEUE_PATH/normal/$WC
rm -f $MJM_QUEUE_PATH/low/$WC
rm -f $MJM_QUEUE_PATH/very-low/$WC

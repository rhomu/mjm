#!/bin/bash

# Print help. Usage
#
#    mjm help [command]
#

if [ -z $1 ]
then
  cat $MJM_PATH/help/mjm.help
else
  cat $MJM_PATH/help/$1.help
fi

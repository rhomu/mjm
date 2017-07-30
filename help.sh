#!/bin/bash

# Print help. Usage
#
#    mjm help [command]
#

if [ -z $1 ]
then
  cat $MJM_PATH/mjm.help
else
  cat $MJM_PATH/$1.help
fi

#!/bin/bash

# Attach to a running session. Usage:
#
#    mjm attach job
#

# attach
screen -r $( mjm pid $1 )

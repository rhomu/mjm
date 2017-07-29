#!/bin/bash

# Purge all queue files. Usage
#
#    mjm purge
#

# wait for all jobs to finsh
#mjm wait 1 mjm

rm -f $MJM_QUEUE_PATH/very-high/*
rm -f $MJM_QUEUE_PATH/high/*
rm -f $MJM_QUEUE_PATH/normal/*
rm -f $MJM_QUEUE_PATH/low/*
rm -f $MJM_QUEUE_PATH/very-low/*

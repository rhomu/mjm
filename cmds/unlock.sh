#!/bin/bash

rm -f "$MJM_LOCK_PATH"
trap - INT TERM

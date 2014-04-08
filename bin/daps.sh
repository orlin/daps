#!/bin/bash

if [ $1 = "ssh" ]; then
  # daps.js stdout command
  eval $(daps.js $*)
else
  daps.js $*
fi

#!/bin/bash

# determine if a list $1 contains an item $2
contains() {
  for word in $1; do
    [[ $word = $2 ]] && return 0 # = true
  done
  return 1 # = false
}

# Space-separated list of commands that produce commands to eval.
# Be careful what goes here - running arbitrary strings can be bad!
# TODO: make sure it's a one-line, at least, also strip the /\n$/?
evalist="ssh empty"

if contains $evalist $1 ; then
  # eval daps.js stdout command
  eval $(daps.js $*)
else
  daps.js $*
fi

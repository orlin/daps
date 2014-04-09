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
evalist="ssh blank"
oneline() {
  # exits if a newline is found
  [[ $1 == *$'\n'* ]] && exit 1
}

if contains "$evalist" $1 ; then
  # eval daps.js stdout command
  ( cd $(daps.js path)
    command=$(daps.js $*)
    oneline "$command"
    eval $command
  )
else
  (cd $(daps.js path); daps.js $*)
fi

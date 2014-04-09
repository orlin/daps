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
  if [[ $2 == *$'\n'* ]]; then
    echo "The '$1' should yield exactly one line to eval, exiting instead."
    echo "FYI, here is what was got:"
    echo $2
    exit 1
  fi
}

if contains "$evalist" $1 ; then
  # eval daps.js stdout command
  ( cd $(daps.js path)
    command=$(daps.js $*)
    oneline $* "$command"
    eval $command
  )
else
  (cd $(daps.js path); daps.js $*)
fi

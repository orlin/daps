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
    echo "The 'daps $1' should yield exactly one line to eval, exiting instead."
    echo "FYI, here is what was got:"
    echo $2
    exit 1
  fi
}

# Is running in a sub-shell necessary in order for the `cd path` to be temporary?
( path=$(daps.js path)
  oneline path
  cd $path
  # TODO: if $path is '.' then make sure we are in the right place, or warn.

  if contains "$evalist" $1 ; then
    # eval daps.js <command>
    command=$(daps.js $*)
    oneline $* "$command"
    eval $command
  else
    daps.js $*
  fi
)

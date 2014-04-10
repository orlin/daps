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
  if [[ $1 =~ \n ]]; then
    echo "The 'daps $2' should yield exactly one line to eval, exiting instead."
    echo "FYI, here is what was got:"
    echo "$1"
    exit 1
  else
    return 0 # true
  fi
}

# Is running in a sub-shell necessary in order for the `cd path` to be temporary?
( path=$(daps.js path)
  oneline "$path" "path" && cd $path
  # Make sure we are in the right place, or don't run anything.
  if grep -q "^# daps --" "$path/README.md"; then
    if [[ $1 == "line" ]]; then
      # use it to dev commands with (before adding them to the $evalist)
      shift # removes line from the argv
      line=$(daps.js $*)
      if oneline "$line" "$*" ; then
        echo $line # the command to be
      fi
    elif contains "$evalist" $1 ; then
      # eval daps.js <command> ...
      command=$(daps.js $*)
      oneline "$command" "$*"
      eval $command
    else
      daps.js $*
    fi
  else
    echo "This '$path' path is not the root directory of daps."
    echo "Best set the \$NODE_PATH - or else cd to where daps is found."
  fi
)

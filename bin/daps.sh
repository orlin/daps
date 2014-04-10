#!/bin/bash

# This `daps` mostly delegates to `daps.js <commands>`.
# The few extras are location-independence, automated meta-command eval,
# a small safety mechanism, and a `daps line ...` for daps.js meta-commands
# development.


evalist="ssh blank"

# Space-separated list of commands that produce commands to eval.
# Be careful what goes here - running arbitrary strings can be bad!
# Try `daps line <command>` and add to the list once it looks good.


# exits if a newline is found - a trailing \n is ok
oneline() {
  if [[ $1 == *$'\n'* ]]; then
    echo "The 'daps $2' should yield exactly one line to eval, exiting instead."
    echo "FYI, here is what was got:"
    echo "$1"
    exit 1
  else
    return 0 # true
  fi
}

# determine if a list $1 contains an item $2
contains() {
  for word in $1; do
    [[ $word = $2 ]] && return 0 # = true
  done
  return 1 # = false
}


# make sure we are in the right place, or don't run anything
path=$(daps.js path)
oneline "$path" "path" && cd $path
if ! grep -q "^# daps --" "$path/README.md"; then
  echo
  echo "This '$path' path is not the root directory of daps."
  echo "Best set the \$NODE_PATH - or else cd to where daps is found."
  help="show"
fi

if [[ $1 == "" || $1 == "help" || $help == "show" ]]; then
  # help comes first
  daps.js --help
  echo "  Extras:"
  echo
  echo "    Set \$NODE_PATH to run from anywhere."
  echo "    This daps will be used via Ansible,"
  echo "    Serf events / queries, etc."
  echo

elif [[ $1 == "line" ]]; then
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

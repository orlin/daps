#!/bin/bash

# This `daps` mostly delegates to `daps.js <commands>`.
# The few extras are location-independence, automated meta-command eval,
# a small safety mechanism, and a `daps line ...` for daps.js meta-commands
# development.

# Variables, with assumptions...
bon="bon" # the command of the bon script - matching package.json
base=$(basename "${0##*/}") # ${BASH_SOURCE[0]} would always be $bon
name=${BON_NAME:-$base} # of the node package that is using bon
script="./bin/$name.${BON_EXT:-js}" # relative to the $name package
[ -n "${BON_SCRIPT}" ] && script="${BON_SCRIPT}" # override entirely

# Exits if a newline is found - a trailing \n is ok.
oneline() {
  if [[ $1 == *$'\n'* ]]; then
    echo "The '$name $2' should yield exactly one line to eval, exiting instead."
    echo "FYI, here is what was got:"
    echo "$1"
    exit 1
  else
    return 0 # true
  fi
}

# Determine if a list $1 contains an item $2.
contains() {
  for word in $1; do
    [[ $word = $2 ]] && return 0 # = true
  done
  return 1 # = false
}

# Source a file if it exists.
include () {
  [[ -f "$1" ]] && source "$1"
}


# Go to the right path - this is verified further down.
path=$(coffee -e '\
process.stdout.write (\
  if process.env.NODE_PATH is undefined then "."\
  else process.env.NODE_PATH.split(":")[0] + "/$name")'
)
cd $path

# Make sure we are in the right place, or don't run anything.
if [[ "$BON_CHECK" == "no" ]]; then
  path_ok="yes" # is it ok not to check?  yes, in some cases.
else
  [ -z "$BON_CHECK_FILE" ] && BON_CHECK_FILE=$path/package.json
  if [[ -f "$BON_CHECK_FILE" ]]; then
    if [ -z "$BON_CHECK_GREP" ]; then
      package=$(coffee -e "process.stdout.write \
        require('$path/package.json').name")
      if [[ $name == $package ]]; then
        path_ok="yes"
      fi
    elif grep -q $BON_CHECK_GREP "$path/$BON_CHECK_FILE"; then
      path_ok="yes"
    fi
  fi
fi

# The moment of $path_ok truth.
if [ "$path_ok" == "yes" ]; then
    # If this was run via $bon, provide an easy way to load more vars.
    [[ $base == $bon ]] && include ./bin/bonvars.sh

    # Space-separated list of commands that produce commands to eval.
    # Be careful what goes here - running arbitrary strings can be bad!
    # Try `<name> line <command>` and add to the list once it looks good.
    evalist="${BON_EVALIST}"
else
  echo
  echo "This '$path' path is not the root directory of $name."
  echo "Best set the \$NODE_PATH - or else cd to where $name is found."
  help="show"
fi


# The order of `daps` commands matters.
# The sequence of if and elifs shouldn't be rearranged!

if [[ $1 == "" || $1 == "help" || $help == "show" ]]; then
  # help comes first
  daps.js --help
  echo "  Configuration:"
  echo
  echo "    Set \$NODE_PATH to run $name from anywhere."
  echo

elif [[ $1 == "line" ]]; then
  # use it to dev commands with (before adding them to the $evalist)
  shift # removes line from the argv
  line=$($script $*)
  if oneline "$line" "$*" ; then
    echo $line # the command to be
  fi

elif contains "$evalist" $1 ; then
  # eval daps.js <command> ...
  command=$($script $*)
  oneline "$command" "$*"
  eval $command

else
  # delegate
  $script $*
fi

#!/usr/bin/env ../node_modules/.bin/coffee

# Usage: `path.coffee <module>`

process.stdout.write (
  if process.env.NODE_PATH is undefined then '.'
  else
    process.exit(1) if process.argv[2] is undefined
    # TODO: improve with several paths by checking each one
    # ... for presence of process.argv[2] directory
    "#{process.env.NODE_PATH.split(':')[0]}/#{process.argv[2]}"
)

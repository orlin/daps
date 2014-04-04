gulp = require("gulp")
gutil = require("gulp-util")
# path = require("path")
exec = require("child_process").exec
help = require("gulp-task-listing")
# fs = require("fs")
# print = require("gulp-print") # debug


gulp.task "help", help

gulp.task "default", help


# docker images | grep {repositoryID}
imageID = (line) ->
  line.match(/^\S+\s+\S+\s+(\S+)/)[1]

# docker ps | grep {repositoryID}
containerID = (line) ->
  line.match(/^(\S+)/)[1]

# docker inspect {containerID} | grep IPAddress
containerIP = (line) ->
  line.match(/([^"]+)",?\s*$/)[1]


gulp.task "init", ->
  console.log "see trello card..."

gulp.task "build-ab", ->
  exec "docker build --rm -t astrolet/ab ."
  , (error, stdout, stderr) ->
    process.stdout.write(stdout)
    process.stdout.write(stderr) if stderr
    console.log("[build] error(s) above") if error isnt null

gulp.task "ssh-ab", ->
  exec "docker ps | grep astrolet/ab"
  , (error, stdout, stderr) ->
    process.stdout.write(stderr) if stderr
    console.log error if error isnt null
    console.log "docker inspect #{containerID(stdout)} | grep IPAddress"
    exec "docker inspect #{containerID(stdout)} | grep IPAddress"
    , (error, stdout, stderr) ->
      process.stdout.write(stderr) if stderr
      console.log error if error isnt null
      console.log "ssh -i tmp/insecure_key root@#{containerIP(stdout)}"

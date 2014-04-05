gulp = require("gulp")
exec = require("child_process").exec
help = require("gulp-task-listing")


gulp.task "help", help

gulp.task "default", help


# exec #simple
exe = (cmd, cb) ->
  exec cmd, (error, stdout, stderr) ->
    process.stdout.write(stderr) if stderr
    if error isnt null
      console.log(error)
    else if cb?
      cb(stdout)
    else
      process.stdout.write(stdout)

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
  exe "docker build --rm -t astrolet/ab ."

gulp.task "shell-ab", ->
  exe "docker ps | grep astrolet/ab", (stdout) ->
    exe "docker inspect #{containerID(stdout)} | grep IPAddress", (stdout) ->
      console.log "ssh -i tmp/insecure_key root@#{containerIP(stdout)}"

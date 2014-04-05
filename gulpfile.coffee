gulp = require("gulp")
help = require("gulp-task-listing")
{exec, spawn} = require("child_process")


gulp.task "help", help

gulp.task "default", help


# exec #simple
exe = (cmd, cb) ->
  exec cmd, (error, stdout, stderr) ->
    process.stderr.write(stderr) if stderr
    if error isnt null
      console.log(error)
    else if cb?
      cb(stdout)
    else
      process.stdout.write(stdout)

# spawn #simple
run = (cmd) ->
  args = cmd.split /\s+/
  command = args.shift()
  chips = spawn(command, args)
  chips.stdout.on "data", (data) ->
    process.stdout.write(data)
  chips.stderr.on "data", (data) ->
    process.stderr.write(data)
  chips.on "error", (err) ->
    console.error "Error:\n#{JSON.stringify(err, null, 2)}"
  chips.on "close", (code) ->
    unless code is 0
      console.log "This `#{cmd}` process exited with code #{code}."

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
  run "docker build --rm -t astrolet/ab ."

gulp.task "shell-ab", ->
  exe "docker ps | grep astrolet/ab", (stdout) ->
    exe "docker inspect #{containerID(stdout)} | grep IPAddress", (stdout) ->
      console.log "ssh -i tmp/insecure_key root@#{containerIP(stdout)}"

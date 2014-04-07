daps = require("commander")
{exec, spawn} = require("child_process")


# exec #simple
exe = (cmd, cb) ->
  exec cmd, (err, stdout, stderr) ->
    process.stderr.write(stderr) if stderr
    if err isnt null
      console.trace JSON.stringify(err, null, 2)
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
    console.trace JSON.stringify(err, null, 2)
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


daps.version("0.0.1")

daps
  .command("build [repo]")
  .description("")
  .action (repo = "astrolet/ab") ->
    console.log "docker build #{repo}"
    run "docker build --rm -t #{repo} ."

daps
  .command("ssh [repo]")
  .description("")
  .action (repo = "phusion/baseimage") ->
    console.log "docker run #{repo} container and provide an ssh command string"
    exe "docker ps | grep #{repo}", (stdout) ->
      exe "docker inspect #{containerID(stdout)} | grep IPAddress", (stdout) ->
        console.log "ssh -i tmp/insecure_key root@#{containerIP(stdout)}"

daps.parse(process.argv)

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
  .description("docker build the Dockerfile base image <repository>")
  .action (repo = "astrolet/ab") ->
    run "docker build --rm -t #{repo} ."

daps
  .command("ssh [repo]")
  .description("docker run a transient <repository> container and produce a command to ssh with")
  .action (repo = "phusion/baseimage") ->
    exe "docker ps | grep #{repo}", (stdout) ->
      exe "docker inspect #{containerID(stdout)} | grep IPAddress", (stdout) ->
        console.log "ssh -i tmp/insecure_key root@#{containerIP(stdout)}"
daps
  .command("empty")
  .description("a command that does nothing, used to test the daps bash script with")
  .action ->
    console.log "" # just a "\n"

daps.parse(process.argv)

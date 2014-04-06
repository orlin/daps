daps = require("commander")

daps.version("0.0.1")

daps
  .command("build [repo]")
  .description("")
  .action (repo) ->
    console.log "docker build #{repo}"

daps
  .command("ssh [repo]")
  .description("")
  .action (repo) ->
    console.log "docker run #{repo} container and provide an ssh command string"

daps.parse(process.argv)

daps = require("commander")
{mp, exe, run} = require("./helpers")


# docker images | grep {repositoryID}
imageID = (line) ->
  line.match(/^\S+\s+\S+\s+(\S+)/)[1]

# docker ps | grep {repositoryID}
containerID = (line) ->
  line.match(/^(\S+)/)[1]

# docker inspect {containerID} | grep IPAddress
containerIP = (line) ->
  line.match(/([^"]+)",?\s*$/)[1]


daps.version(require("../package.json").version)

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
        process.stdout.write "ssh -i tmp/insecure_key root@#{containerIP(stdout)}"

daps
  .command("blank")
  .description("a command that does nothing, used to test the daps bash script with")
  .action -> process.stdout.write '\n' # the last \n gets stripped with $() on the bash side

daps
  .command("path")
  .description("the daps module path - based on $NODE_PATH or else .")
  .action ->
    process.stdout.write (
      # TODO: improve with several paths by checking each one for daps/ presence
      # NOTE: must run daps from its module dir if $NODE_PATH isn't set
      np = process.env.NODE_PATH
      if np is undefined then '.' else np.split(':')[0] + "/daps"
    )

daps.parse(process.argv)

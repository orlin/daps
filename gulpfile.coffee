gulp = require("gulp")
help = require("gulp-task-listing")

gulp.task "help", help

gulp.task "default", help


gulp.task "init", ->
  console.log "will probably be a commander `daps init`, see trello card..."

# NOTE: there would probably be a need for gulp tasks eventually,
# thus keeping this empty for now gulpfile...

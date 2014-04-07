gulp = require("gulp")
help = require("gulp-task-listing")

gulp.task "help", help

gulp.task "default", help


gulp.task "init", ->
  console.log "see trello card..."

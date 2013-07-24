express = require 'express'
app = module.exports = express()

app.use express.favicon "#{__dirname}/.build/chrome-app/favicon.ico"
app.use express.static "#{__dirname}/.build/chrome-app"

unless module.parent?
  app.listen process.env.PORT ? 3000, ->
    console.log 'up & running'

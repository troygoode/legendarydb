express = require 'express'
app = module.exports = express()

app.set 'view engine', 'jade'
app.set 'views', "#{__dirname}/views"

app.get '/', (req, res) ->
  res.render 'home'

unless module.parent?
  app.listen process.env.PORT ? 3000, ->
    console.log 'up & running'

# SessionController

lib = require './library'
promise = require 'request-promise'

url = 'http://localhost:3000/api/Certification'

_options =
  headers: 'User-Agent': 'Request-Promise'
  json: true
  url: url

module.exports =
  new: (req, res) ->
    res.view()


  create: (req, res) ->
    res.redirect('http://localhost:1337/receivers/A103742006')

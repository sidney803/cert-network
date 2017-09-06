prettyjson = require('prettyjson')

module.exports =
  log: (message, title="notitle") ->
    console.log '---', title, '---'

    options = stringColor: 'blue'
    try
      object = JSON.parse(message)
      console.log prettyjson.render(object, options)
    catch e
      console.log prettyjson.render(message, options)

    console.log '---', title, '---'

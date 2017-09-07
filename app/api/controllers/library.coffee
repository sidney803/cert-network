prettyjson = require('prettyjson')

module.exports =
  log: (message, title="notitle") ->
    console.log '---', title, '---'

    options = stringColor: 'blue'
    if message
      try
        object = JSON.parse(message)
        console.log prettyjson.render(object, options)
      catch e
        console.log prettyjson.render(message, options)

    console.log '-----------------------------------------------', title, '---\n'

  guid: ->
    s4 = ->
      Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
    s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()

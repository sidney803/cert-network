prettyjson = require('prettyjson')
promise = require('request-promise')

_options =
  headers: 'User-Agent': 'Request-Promise'
  json: true


module.exports =
  log: (message, title="no-title") ->
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

  getClassList: (className, callback) ->
    module = this
    options = _.clone _options
    options.uri = 'http://localhost:3000/api/org.pccu.certnetwork.'+ className
    module.log options, 'options'
    promise(options).then((results) ->
      module.log results, 'results'
      callback results
    ).catch (err) ->
      module.log err, 'error'

  getIssuers: (callback) ->
    this.getClassList "Issuer", callback

  getReceivers: (callback) ->
    this.getClassList "Receiver", callback


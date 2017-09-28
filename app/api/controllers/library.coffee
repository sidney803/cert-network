prettyjson = require('prettyjson')
promise = require('request-promise')

_options =
  headers: 'User-Agent': 'Request-Promise'
  json: true

api = 'http://localhost:3000/api/org.pccu.certnetwork.'

module.exports =
  zip: (data, callback) ->
    console.log 1
    fs = require 'fs'
    targz = require 'tar.gz'
    tempfile = "/tmp/data"
    tarfile = 'temp.tar.gz'
    console.log 2

    fs.writeFile tempfile, data, (err) ->
      console.log 3
      if err
        console.log 4
        console.log err
        return
      console.log 5




      read = targz().createReadStream('/some/directory')
      write = fs.createWriteStream('compressed.tar.gz')
      read.pipe write


      read = targz().createReadStream tempfile
      write = fs.createWriteStream tarfile
      read.pipe write

      fs.readFile tarfile, (err, data) ->
        if err
          console.log err
          return
        callback data

    # LZUTF8 = require('lzutf8')
    # return LZUTF8.compress(data)

  unzip: (data) ->
    # zlib = require 'zlib'
    # return zlib.inflateSync(new Buffer(data, 'base64')).toString()
    LZUTF8 = require('lzutf8')
    return LZUTF8.decompress(data)


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
    options.uri = api + className
    # module.log options, 'options'
    promise(options).then((results) ->
      # module.log results, 'results'
      callback results
    ).catch (err) ->
      module.log err, 'error'

  getIssuers: (callback) ->
    this.getClassList "Issuer", callback

  getReceivers: (callback) ->
    this.getClassList "Receiver", callback

  getCerts: (callback) ->
    this.getClassList "Cert", callback

  get: (className, id, callback) ->
    module = this
    options = _.clone _options
    options.uri = api + className + "/" + id
    module.log options, 'options'
    promise(options).then((result) ->
      module.log result, 'result'
      callback result
    ).catch (err) ->
      module.log err, 'error'


 # ReceiverController
lib = require('./library')
promise = require('request-promise')

url = 'http://localhost:3000/api/org.pccu.certnetwork.Receiver'
_options =
  headers: 'User-Agent': 'Request-Promise'
  json: true

module.exports =
  new: (req, res) ->
    message = ""
    if req.session.message && req.session.message.error
      message = req.session.message.error.message
    lib.log message
    req.session.message = {}
    res.view({message: message})

  create: (req, res) ->
    params = req.body
    data =
      "$class": "org.pccu.certnetwork.Receiver",
      "receiverId": params.identify
      "firstName": params.firstname
      "lastName": params.lastname
    lib.log data
    options =
      method: "POST"
      uri: url
      headers: 'User-Agent': 'Request-Promise'
      json: true
      body: data

    promise(options).then((result) ->
      lib.log result, 'result'
      res.redirect("/receivers")
      ).catch (err) ->
        message = JSON.parse(err.message.replace('500 -', ''))
        lib.log message
        req.session.message = message
        res.redirect("/receivers/new")

  index: (req, res) ->
    options =
      uri: url
      headers: 'User-Agent': 'Request-Promise'
      json: true
    promise(options).then((result) ->
      collection = result
      res.view('receiver/index.ejs', {collection: collection})
    ).catch (err) ->
      lib.log err

  destroy: (req, res) ->
    options = _.clone _options
    options.uri = url + "/" + req.params.id
    options.method = "DELETE"

    promise(options).then((result) ->
      res.status 200
      res.send("success")
    ).catch (err) ->
      res.status 500
      res.send("error")



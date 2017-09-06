 # ReceiverController
lib = require('./library')
promise = require('request-promise')

module.exports =
  new: (req, res) ->
    message = ""
    if req.session.message.error
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
    url = 'http://localhost:3000/api/org.pccu.certnetwork.Receiver'
    lib.log data
    options =
      method: "POST"
      uri: url
      headers: 'User-Agent': 'Request-Promise'
      json: true
      body: data

    promise(options).then((repos) ->
      lib.log repos
      res.redirect("/receivers")
      ).catch (err) ->
        message = JSON.parse(err.message.replace('500 -', ''))
        lib.log message
        req.session.message = message
        res.redirect("/receivers/new")

  index: (req, res) ->
    url = 'http://localhost:3000/api/org.pccu.certnetwork.Receiver'
    options =
      uri: url
      headers: 'User-Agent': 'Request-Promise'
      json: true
    promise(options).then((result) ->
      collection = result
      res.view('receiver/index.ejs', {collection: collection})
    ).catch (err) ->
      lib.log err


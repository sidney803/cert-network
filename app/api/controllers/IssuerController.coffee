# IssuerController
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
      "$class": "org.pccu.certnetwork.Issuer",
      "issuerId": params.identify
      "issuerName": params.name
    lib.log data
    url = url = 'http://localhost:3000/api/org.pccu.certnetwork.Issuer'
    options =
      method: "POST"
      uri: url
      headers: 'User-Agent': 'Request-Promise'
      json: true
      body: data

    promise(options).then((repos) ->
      lib.log repos
      res.redirect('/issuers')
      ).catch (err) ->
        message = JSON.parse(err.message.replace('500 -', ''))
        lib.log message
        req.session.message = message
        res.redirect("/issuers/new")

  index: (req, res) ->
    url = url = 'http://localhost:3000/api/org.pccu.certnetwork.Issuer'
    options =
      uri: url
      headers: 'User-Agent': 'Request-Promise'
      json: true
    promise(options).then((result) ->
      lib.log result, 'result'
      collection = result
      res.view('issuer/index.ejs', {collection: collection})
      ).catch (err) ->
        lib.log err


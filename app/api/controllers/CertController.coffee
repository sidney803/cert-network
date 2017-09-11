# CertController
lib = require('./library')
promise = require('request-promise')

url = 'http://localhost:3000/api/org.pccu.certnetwork.Cert'
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

    options = _.clone _options
    options.uri = 'http://localhost:3000/api/org.pccu.certnetwork.Receiver'
    promise(options).then((result) ->
      res.view({message: message, receivers: result})
    ).catch (err) ->
      lib.log err


  create: (req, res) ->
    options = _.clone _options
    params = req.body
    data =
      "$class": "org.pccu.certnetwork.Cert",
      "certId": lib.guid()
      "certTitle": params.certTitle
      "certStatus": params.certStatus
      "issueDate": params.issueDate
      "certExpiredDate": params.certExpiredDate
      "info": params.info
      "thumbnail": params.thumbnail
      "receiver": params.receiver
      "issuer": params.issuer
    lib.log data, 'data'

    options.uri = url
    options.method = "POST"
    options.body = data

    lib.log options, 'options'

    promise(options).then((result) ->
      lib.log result, 'result'
      res.redirect('/certs')
    ).catch (err) ->
      lib.log err, 'err'
      message = JSON.parse(err.message.replace('500 -', ''))
      lib.log message
      req.session.message = message
      res.redirect("/certs/new")

  index: (req, res) ->
    options = _.clone _options
    options.uri = url
    lib.log options, 'options'
    promise(options).then((result) ->
      lib.log result, 'result'
      collection = result
      res.view('cert/index.ejs', {collection: collection})
    ).catch (err) ->
      lib.log err

  destroy: (req, res) ->
    lib.log req.params, 'req.params'
    options = _.clone _options
    options.uri = url + "/" + req.params.id
    options.method = "DELETE"
    lib.log options, 'options'

    promise(options).then((result) ->
      lib.log result, 'result'
      res.status 200
      res.send("success")
    ).catch (err) ->
      lib.log err, 'err'
      res.status 500
      res.send("error")


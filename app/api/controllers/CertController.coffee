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
    lib.getReceivers (receivers) ->
      lib.getIssuers (issuers) ->
        res.view({message: message, receivers: receivers, issuers: issuers})

  create: (req, res) ->
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

    options = _.clone _options
    options.uri = url
    options.method = "POST"
    options.body = data
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
      lib.getReceivers (receivers) ->
        lib.getIssuers (issuers) ->
          res.view('cert/index.ejs', {collection: collection, issuers: issuers, receivers: receivers})
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






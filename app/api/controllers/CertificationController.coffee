# CertificationController

lib = require './library'
promise = require 'request-promise'

url = 'http://localhost:3000/api/Certification'

_options =
  headers: 'User-Agent': 'Request-Promise'
  json: true
  url: url

module.exports =
  imports: (req, res) ->
    host = req.get('host')
    options = _.clone _options
    options.url = "http://140.137.200.243/bizapi_bc/api/AppCert/GetCertList?GetSDate=2017/12/1&GetEDate=2017/12/4"
    lib.log options, 'options'
    promise(options).then((result) ->
      lib.log result.Data, 'result'
      items = result.Data
      lib.log items.length, 'items.length'
      options.method = "POST"
      res.redirect('/certifications')
      lib.import req, options, items, 0, ->
        res.redirect('/certifications')
    ).catch (err) ->
      lib.log err, 'err'
      res.redirect('/certifications')

  new: (req, res) ->
    message = ""
    if req.session.message && req.session.message.error
      message = req.session.message.error.message
    req.session.message = {}
    res.view({ message: message })

  create: (req, res) ->
    params = req.body
    lib.log params, 'params'
    data =
      "$class": "org.pccu.certnetwork.Certification",
      "certificationId": params.issuerName + "-" + params.certNo,
      "certNo": params.certNo,
      "certTitle": params.certTitle,
      "issueDate": params.issueDate,
      "certExpiredDate": params.certExpiredDate,
      "thumbnail": params.thumbnail,
      "receiverId": params.receiverId,
      "receiverFirstName": params.receiverFirstName,
      "receiverLastName": params.receiverLastName,
      "issuerName": params.issuerName,
      "certStatus": params.certStatus,
      "info": params.info

    options = _.clone _options
    options.method = "POST"
    options.body = data

    promise(options).then((result) ->
      lib.log result, 'result'
      res.redirect('/certifications')
    ).catch (err) ->
      lib.log err, 'err'
      message = JSON.parse(err.message.replace(/\d\d\d\s-/g, ''))
      lib.log message
      req.session.message = message
      res.redirect("/certifications/new")

  index: (req, res) ->
    options = _.clone _options
    lib.log options, 'options'
    promise(options).then((result) ->
      lib.log result, 'result'
      collection = result
      lib.log collection, 'collection'
      res.view('certification/index.ejs', { collection: collection })
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







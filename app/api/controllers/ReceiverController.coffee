 # ReceiverController
lib = require('./library')
promise = require('request-promise')

url = 'http://localhost:3000/api/org.pccu.certnetwork.Receiver'
_options =
  headers: 'User-Agent': 'Request-Promise'
  json: true
  uri: url

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
    options = _.clone _options
    options.method = "POST"
    options.body = data

    promise(options).then((result) ->
      lib.log result, 'result'
      res.redirect("/receivers")
      ).catch (err) ->
        message = JSON.parse(err.message.replace('500 -', ''))
        lib.log message
        req.session.message = message
        res.redirect("/receivers/new")

  index: (req, res) ->
    options = _.clone _options
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

  show: (req, res) ->
    id = req.params.id
    lib.get "Receiver", id, (receiver) ->
      lib.getCerts (certs) ->
        lib.log certs, 'certs'
        lib.log certs.length, 'certs'
        certs = _.filter certs, (cert) ->
          # cert.receiverId.indexOf(id) != -1
          cert.receiverId == id
        lib.log certs.length, 'certs'
        res.view('receiver/show.ejs', { receiver: receiver, certs: certs })

  show____chaincode: (req, res) ->
    options = _.clone _options
    # issuer_url = "http://localhost:3000/api/org.pccu.certnetwork.Issuer?filter=%7B%22where%22%3A%20%7B%22issuerId%22%3A%22450f8561-e5b9-9669-af8b-50addef29e86%22%7D%7D"
    # options.uri = issuer_url
    action = "Issuer"
    field = "issuerId"
    key = "450f8561-e5b9-9669-af8b-50addef29e86"

    action = "Cert"
    field = "receiverId"
    # key = "resource:org.pccu.certnetwork.Receiver#A123456789"
    key = "A123456789"

    options.uri = "http://localhost:3000/api/org.pccu.certnetwork." + action + "?filter=%7B%22where%22%3A%20%7B%22" + field + "%22%3A%22" + key + "%22%7D%7D"
    lib.log options, 'options'
    promise(options).then((result) ->
      lib.log result
    ).catch (err) ->
      lib.log err, 'err'

    res.view()











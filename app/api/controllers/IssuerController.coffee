# IssuerController
lib = require('./library')
promise = require('request-promise')

url = 'http://localhost:3000/api/Issuer'
_options =
  headers: 'User-Agent': 'Request-Promise'
  json: true
  uri: url

'use strict'

hfc = require 'fabric-client'
channel = {}
client = null

module.exports =
  new: (req, res) ->
    message = ""
    if req.session.message && req.session.message.error
      message = req.session.message.error.message
    lib.log message
    req.session.message = {}
    res.view({message: message})

  create: (req, res) ->
    options = _.clone _options
    params = req.body
    data =
      "$class": "org.pccu.certnetwork.Issuer",
      "issuerId": lib.guid()
      "issuerName": params.name
    lib.log data
    options.method = "POST"
    options.body = data

    promise(options).then((result) ->
      lib.log result
      res.redirect('/issuers')
      ).catch (err) ->
        message = JSON.parse(err.message.replace('500 -', ''))
        lib.log message
        req.session.message = message
        res.redirect("/issuers/new")

  index: (req, res) ->
    options = _.clone _options
    promise(options).then((result) ->
      lib.log result, 'result'
      collection = result
      res.view('issuer/index.ejs', {collection: collection})
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
    lib.get 'Issuer', id, (issuer) ->
      lib.getCerts (certs) ->
        lib.log certs, 'certs'
        lib.log certs.length, 'certs'
        certs = _.filter certs, (cert) ->
          cert.issuerId.indexOf(id) != -1
        lib.log certs.length, 'certs'
        res.view('issuer/show.ejs', { issuer: issuer, certs: certs })


  show__by_chaincode: (req, res) ->
    options =
      uri: 'grpc://localhost:7051'
      path: "/Users/ctslin/fabric-tools/fabric-scripts/hlfv1/composer/creds"
      user_id: 'PeerAdmin'
      network_url: 'grpc://localhost:7051'
      channel_id: 'cert-network'

    Promise.resolve().then( ->
      client = new hfc()
      return hfc.newDefaultKeyValueStore { path: options.path }
    ).then((wallet) ->
      client.setStateStore wallet
      lib.log client, 'client'
      return client.getUserContext options.user_id, true
    ).then((user) ->
      lib.log user, 'user'
      if user == null or user.isEnrolled() == false
        lib.log 'User not defined, or not enrolled - error'
      else
        channel = client.newChannel options.channel_id
        channel.addPeer client.newPeer(options.network_url)
      return
    ).then( ->
      lib.log channel, 'channel'
      trans_id = client.newTransactionID()
      lib.log trans_id, 'trans_id'
    ).catch (err) ->
      lib.log err, 'err'


    res.view()
  show__________: (req, res) ->
    id = req.params.id
    options = _.clone _options

    action = "Issuer"
    field = "issuerId"
    key = id

    action = "Cert"
    field = "issuerId"
    # # key = "resource:org.pccu.certnetwork.Receiver#A123456789"

    # field = "issuerName"
    key = "aaa"

    field = "certId"
    key = "26809638-f0d6-16cc-d5ab-b7a8c2f555d6"

    field = "receiver"
    key = "A123456789"

    options.uri = "http://localhost:3000/api/" + action + "?filter=%7B%22where%22%3A%20%7B%22" + field + "%22%3A%22" + key + "%22%7D%7D"

    lib.log options, 'options'
    promise(options).then((result) ->
      lib.log result
    ).catch (err) ->
      lib.log err, 'err'

    res.view()


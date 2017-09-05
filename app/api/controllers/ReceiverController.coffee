 # ReceiverController
 #
 # @description :: Server-side actions for handling incoming requests.
 # @help        :: See https://sailsjs.com/docs/concepts/actions

promise = require('request-promise')
prettyjson = require('prettyjson');

module.exports =
  new: (req, res) ->
    res.view()

  create: (req, res) ->
    params = req.body
    data =
      "$class": "org.pccu.certnetwork.Receiver",
      "receiverId": params.identify
      "firstName": params.firstname
      "lastName": params.lastname
    url = 'http://localhost:3000/api/org.pccu.certnetwork.Receiver'
    log data
    options =
      uri: url
      headers: 'User-Agent': 'Request-Promise'
      json: true
    options.method = "POST"
    options.body = data
    promise(options).then((repos) ->
      log repos
      res.redirect("/receivers")
      ).catch (err) ->
        message = err.message.replace('500 -', '')
        res.redirect("/receivers/new")

  index: (req, res) ->
    collection = [ {
      '$class': 'org.pccu.certnetwork.Receiver'
      receiverId: '111'
      firstName: '大丙'
      lastName: '王'
    }, {
      '$class': 'org.pccu.certnetwork.Receiver'
      receiverId: '222'
      firstName: '大丙'
      lastName: '王' }]
    url = 'http://localhost:3000/api/org.pccu.certnetwork.Receiver'
    options =
      uri: url
      headers: 'User-Agent': 'Request-Promise'
      json: true
    promise(options).then((result) ->
      collection = result
      res.view('receiver/index.ejs', {collection: collection})
    ).catch (err) ->


log = (message, title="notitle") ->
  console.log '---', title, '---'

  options = stringColor: 'blue'
  try
    object = JSON.parse(message)
    console.log prettyjson.render(object, options)
  catch e
    console.log prettyjson.render(message, options)

  console.log '---', title, '---'

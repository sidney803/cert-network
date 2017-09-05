module.exports.routes = {

  '/': { view: 'homepage' },
  'get /receivers/new': 'ReceiverController.new',
  'get /receivers': 'ReceiverController.index',
  'post /receivers': 'ReceiverController.create'

};

module.exports.routes = {

  '/': { view: 'homepage' },

  'get /issuers/new': 'IssuerController.new',
  'get /issuers': 'IssuerController.index',
  'post /issuers': 'IssuerController.create',

  'get /receivers/new': 'ReceiverController.new',
  'get /receivers': 'ReceiverController.index',
  'post /receivers': 'ReceiverController.create',

};

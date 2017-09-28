module.exports.routes = {

  '/': { view: 'homepage' },

  'get /issuers/new': 'IssuerController.new',
  'get /issuers': 'IssuerController.index',
  'get /issuers/:id': 'IssuerController.show',
  'post /issuers': 'IssuerController.create',
  'delete /issuers/:id': {
    controller  : 'issuer',
    action    : 'destroy'
  },

  'get /receivers/new': 'ReceiverController.new',
  'get /receivers': 'ReceiverController.index',
  'get /receivers/:id': 'ReceiverController.show',
  'post /receivers': 'ReceiverController.create',
  'delete /receivers/:id': {
    controller  : 'receiver',
    action    : 'destroy'
  },

  'get /certs/new': 'CertController.new',
  'get /certs': 'CertController.index',
  'post /certs': 'CertController.create',
  // 'delete /certs': 'CertController.destroy',
  'delete /certs/:id': {
    controller  : 'cert',
    action    : 'destroy'
  }

};

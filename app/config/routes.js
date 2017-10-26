module.exports.routes = {

  '/': { view: 'homepage' },

  'get /issuers/new': 'IssuerController.new',
  'get /issuers': 'IssuerController.index',
  'get /issuers/:id': 'IssuerController.show',
  'post /issuers': 'IssuerController.create',
  'delete /issuers/:id': 'IssuerController.destroy',

  'get /receivers/new': 'ReceiverController.new',
  'get /receivers': 'ReceiverController.index',
  'get /receivers/:id': 'ReceiverController.show',
  'post /receivers': 'ReceiverController.create',
  'delete /receivers/:id': 'ReceiverController.destroy',

  'get /certs/new': 'CertController.new',
  'get /certs': 'CertController.index',
  'post /certs': 'CertController.create',
  'delete /certs/:id': 'CertController.destroy',

  'get /certifications/new': 'CertificationController.new',
  'get /certifications': 'CertificationController.index',
  'post /certifications': 'CertificationController.create',
  'delete /certifications/:id': 'CertificationController.destroy'

};

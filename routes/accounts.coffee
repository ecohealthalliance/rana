AccountsTemplates.configureRoute "signIn"

AccountsTemplates.addField
  _id: 'name'
  type: 'text'
  displayName: 'Name'
  required: true

AccountsTemplates.addField
  _id: 'organization'
  type: 'text'
  displayName: 'Organization'
  required: false

AccountsTemplates.addField
  _id: 'phone'
  type: 'tel'
  displayName: 'Phone'
  required: false

  
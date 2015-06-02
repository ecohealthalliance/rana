UserProfileSchema = share.UserProfileSchema

keyToLabel = (key)->
  label = key[0].toUpperCase()
  for c in key.substr(1)
    if c == c.toUpperCase()
      label += " " + c.toLowerCase()
    else
      label += c
  return label

AccountsTemplates.configureRoute "signIn",
  path: '/grrs/sign-in'

AccountsTemplates.configure
  showPlaceholders: false
  continuousValidation: true
  texts:
    optionalField: ''

AccountsTemplates.removeField 'email'
AccountsTemplates.removeField 'password'
AccountsTemplates.addFields ([
  {  
    '_id': 'email'
    type: 'email'
    displayName: "Email"
    required: true
    template: 'registerCustom'
    options:
      beginRequired: true
  },
  {  
    '_id': 'password'
    type: 'password'
    displayName: "Password"
    re: /(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,}/
    required: true
    template: 'registerCustom'
  },
  {  
    '_id': 'password_again'
    type: 'password'
    displayName: "Password (again)"
    re: /(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,}/
    required: true
    template: 'registerCustom'
  }
])

schema = UserProfileSchema.schema()

for key in _.keys schema
  field = schema[key]

  if key is 'organizationPostalCode' or key is 'organizationStateOrProvince'
    template = 'registerSmallRow'
  else if key is 'phone'
    template = 'registerSmallSolo'
  else if key is 'organization' or  key is 'organizationCountry' or key is 'organizationCity' or key is 'organizationStreet2'
    template = 'registerMed'
  else 
    template = 'registerCustom'

  if key is 'organization'
    options =
      optionalInfo: true
  else 
    options = {}

  AccountsTemplates.addField
    _id: key
    type: 'text'
    displayName: field.label or keyToLabel(key)
    required: if field.optional then false else true
    template: template
    options: options


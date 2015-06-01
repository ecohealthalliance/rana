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

schema = UserProfileSchema.schema()
for key in _.keys schema
  field = schema[key]

  AccountsTemplates.addField
    _id: key
    type: 'text'
    displayName: field.label or keyToLabel(key)
    required: if field.optional then false else true

if Meteor.isServer
  Accounts.onCreateUser (options, user) ->
    # TODO how to make the first rana admin approved by default?
    user.approval = 'pending'
    user.profile = options.profile
    user


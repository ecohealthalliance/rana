UserProfileSchema = share.UserProfileSchema

keyToLabel = (key)->
  label = key[0].toUpperCase()
  for c in key.substr(1)
    if c == c.toUpperCase()
      label += " " + c.toLowerCase()
    else
      label += c
  return label

AccountsTemplates.configureRoute "signIn"

schema = UserProfileSchema.schema()
for key in _.keys schema
  field = schema[key]

  AccountsTemplates.addField
    _id: key
    type: 'text'
    displayName: field.label or keyToLabel(key)
    required: if field.optional then false else true

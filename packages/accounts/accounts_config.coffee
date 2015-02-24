UserProfileSchema = @UserProfileSchema

AccountsTemplates.configureRoute "signIn"

schema = UserProfileSchema.schema()
for key in _.keys schema
  field = schema[key]

  AccountsTemplates.addField
    _id: key
    type: 'text'
    #displayName: field.label
    required: if field.optional then false else true

  
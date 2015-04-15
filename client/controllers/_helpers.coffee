@contactFromUser = () ->
  profile = Meteor.user()?.profile
  if profile
    email = Meteor.user().emails[0].address
    res = {
      name: profile.name
      email: email
      phone: profile.phone
      institutionAddress:
        name: profile.organization
        street: profile.organizationStreet
        street2: profile.organizationStreet2
        city: profile.organizationCity
        stateOrProvince: profile.organizationStateOrProvince
        country: profile.organizationCountry
        postalCode: profile.organizationPostalCode
    }
    res
  else
    {}

# Copy properties from source to target, not overr
@mergeObjects = (target, source) ->
  if typeof target is 'object' and typeof source is 'object'
    for prop of source
      if prop of target and target[prop] != undefined
        @mergeObjects target[prop], source[prop]
      else
        target[prop] = source[prop]

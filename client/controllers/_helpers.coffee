Template.registerHelper 'contactFromUser', () ->
  user = Meteor.user()
  if user
    profile = Meteor.user().profile
    if profile
      if user.emails and user.emails[0]
        email = user.emails[0].address
      else
        email = null
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
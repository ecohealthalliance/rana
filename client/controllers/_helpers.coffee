getCollections = () -> @collections

Template.registerHelper 'contactFromUser', () ->
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

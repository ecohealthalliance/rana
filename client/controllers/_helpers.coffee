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

# Based on bobince's regex escape function.
# source: http://stackoverflow.com/questions/3561493/is-there-a-regexp-escape-function-in-javascript/3561711#3561711
RegExp.escape = (s)->
  s.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')
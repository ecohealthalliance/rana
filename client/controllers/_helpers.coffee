getCollections = () -> @collections

AutoForm.setDefaultTemplate 'rana'

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

# Based on bobince's regex escape function.
# source: http://stackoverflow.com/questions/3561493/is-there-a-regexp-escape-function-in-javascript/3561711#3561711
regexEscape = (s)->
  s.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')

@generaHandler = _.throttle (e) ->
  generaValues = getCollections().Genera
    .find({
      value:
        $regex: "^" + regexEscape($(e.target).val())
        $options: "i"
    }, {
      limit: 5
    })
    .map((r)-> r.value)

  $("input[name='speciesGenus']").autocomplete
    source: generaValues
, 500

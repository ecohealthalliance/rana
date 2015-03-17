# Based on bobince's regex escape function.
# source: http://stackoverflow.com/questions/3561493/is-there-a-regexp-escape-function-in-javascript/3561711#3561711
regexEscape = (s)->
  s.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')

getCollections = => @collections

AutoForm.addHooks(
  'ranavirus-report', {
    formToDoc: (doc)->
      doc.createdBy = {
        userId: Meteor.userId()
        name: Meteor.user().profile?.name or "None"
      }
      return doc
    onSuccess: (operation, result, template)->
      toastr.options = {
        "closeButton": true,
        "positionClass": "toast-top-center",
        "timeOut": "10000"
      }
      toastr.success(operation + " successful!")
  }
)

Template.form.reportDoc = ->
  params = Iron.controller().getParams()
  if params?.reportId
    return getCollections().Reports.findOne(params.reportId) or {}
  else
    return {
      institutionAddress:
        name: Meteor.user().profile?.organization
        street: Meteor.user().profile?.organizationStreet
        street2: Meteor.user().profile?.organizationStreet2
        city: Meteor.user().profile?.organizationCity
        stateOrProvince: Meteor.user().profile?.organizationStateOrProvince
        country: Meteor.user().profile?.organizationCountry
        postalCode: Meteor.user().profile?.organizationPostalCode
    }

Template.form.type = ->
  params = Iron.controller().getParams()
  if not params?.reportId
    return "insert"
  currentReport = getCollections().Reports.findOne(params.reportId)
  if not currentReport
    # This will trigger an error message
    return null
  if Meteor.userId() and Meteor.userId() == currentReport.createdBy.userId
    return "update"
  return "readonly"

Template.form.events = {
  "keyup input#speciesGenus": _.throttle((e)->
    generaValues = getCollections().Genera
      .find({
        value:
          $regex: "^" + regexEscape($(e.target).val())
          $options: "i"
      }, {
        limit: 5
      })
      .map((r)-> r.value)
    
    $("input#speciesGenus").autocomplete
      source: generaValues
  , 500)
}
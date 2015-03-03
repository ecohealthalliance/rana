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
  report = getCollections().Reports.findOne(@data?.reportId) or {}
  return _.extend({
    institutionAddress:
      name: Meteor.user().profile?.organization
      street: Meteor.user().profile?.organizationStreet
      street2: Meteor.user().profile?.organizationStreet2
      city: Meteor.user().profile?.organizationCity
      stateOrProvince: Meteor.user().profile?.organizationStateOrProvince
      country: Meteor.user().profile?.organizationCountry
      postalCode: Meteor.user().profile?.organizationPostalCode
  }, report)
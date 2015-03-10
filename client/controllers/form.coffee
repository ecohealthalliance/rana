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
      window.scrollTo(0, 0)
  }
)
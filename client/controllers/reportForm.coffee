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
      window.scrollTo(0, 0)
  }
)

Template.reportForm.helpers

  reportDoc: ->
    params = Iron.controller().getParams()
    if params?.reportId
      return getCollections().Reports.findOne(params.reportId) or {}
    else
      { contact: UI._globalHelpers['contactFromUser']() }

  type: ->
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

Template.reportForm.events =
  "keyup input[name='speciesGenus']": @generaHandler

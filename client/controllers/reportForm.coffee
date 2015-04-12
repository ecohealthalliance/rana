getCollections = => @collections

urlParams = null

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
        closeButton: true
        positionClass: "toast-bottom-center"
        timeOut: "100000"
        # This is the timeout after a mouseover event
        extendedTimeOut: "100000"
      }
      toastr.success("""
      <div>#{operation} successful!</div>
      <a href="/report/#{result}">Edit Report</a>
      """)
      window.scrollTo(0, 0)
      redirectOnSubmit =  urlParams?.query?.redirectOnSubmit
      if redirectOnSubmit
        Router.go(redirectOnSubmit)
      else
        window.scrollTo(0, 0)
    onError: (operation, error) ->
      errorLocation = $("""[data-schema-key="#{error.invalidKeys[0].name}"]""")
        .parent()
        .offset()
        ?.top
      window.scrollTo(0, errorLocation) if errorLocation
      toastr.options = {
        closeButton: true
        positionClass: "toast-bottom-center"
      }
      toastr.error(error.message)
  }
)

Template.reportForm.helpers

  reportDoc: =>
    urlParams = Iron.controller().getParams()
    if urlParams?.reportId
      getCollections().Reports.findOne(urlParams.reportId) or {}
    else if Session.get 'studyId'
      getCollections().Studies.findOne Session.get('studyId')
    else
      {
        studyId: @study._id
        contact: UI._globalHelpers['contactFromUser']()
      }

  studySelected: ->
    Session.get 'studyId'

  type: ->
    urlParams = Iron.controller().getParams()
    if not urlParams?.reportId
      return "insert"
    currentReport = getCollections().Reports.findOne(urlParams.reportId)
    if not currentReport
      # This will trigger an error message
      return null
    if Meteor.userId() and Meteor.userId() == currentReport.createdBy.userId
      return "update"
    return "readonly"

Template.reportForm.events

  'change select[name="studyId"]': (e, t) ->
    Session.set  'studyId', AutoForm.getFieldValue('ranavirus-report', 'studyId')

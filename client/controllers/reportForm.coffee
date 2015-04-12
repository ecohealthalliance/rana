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
      message = """<div>#{operation} successful!</div>"""
      message += """<a href="/report/#{result}">Edit Study</a>"""
      toastr.success message
      window.scrollTo 0, 0
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
    reportId = Template.currentData()?.reportId
    if reportId
      getCollections().Reports.findOne(reportId) or {}
    else
      getCollections().Studies.findOne Session.get @study._id

  studySelected: ->
    Session.get 'studyId'

  type: ->
    reportId = Template.currentData()?.reportId
    if not reportId
      "insert"
    else
      currentReport = getCollections().Reports.findOne reportId
      if not currentReport
        # This will trigger an error message
        null
      else if Meteor.userId() and Meteor.userId() == currentReport.createdBy.userId
        "update"
      else
        "readonly"

Template.reportForm.events

  'change select[name="studyId"]': (e, t) ->
    Session.set  'studyId', AutoForm.getFieldValue('ranavirus-report', 'studyId')

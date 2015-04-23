getCollections = => @collections
contactFromUser = @contactFromUser

AutoForm.addHooks(
  'ranavirus-report', {
    docToForm: (doc, ss)->
      if doc
        utils.subscribeToDocFiles(doc)
      return doc
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
      <a href="/report/#{@docId}">Edit Report</a>
      """)
      window.scrollTo(0, 0)
      redirectOnSubmit =  template.data?.query?.redirectOnSubmit
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
    if Template.currentData().report
      Template.currentData().report
    else
      study = _.extend Template.currentData().study, { studyId: Template.currentData().study._id }
      contactFromUser = @contactFromUser()
      @mergeObjects study.contact, contactFromUser
      study

  type: ->
    if not Template.currentData()?.report
      "insert"
    else if Meteor.userId() and Meteor.userId() == Template.currentData().report.createdBy.userId
      "update"
    else
      "readonly"

  reportHeader: ->
    if Template.currentData().report
      studyName = getCollections().Studies.findOne(Template.currentData().report.studyId).name
      "#{ studyName } - Edit Report"
    else
      studyName = Template.currentData().study.name
      "#{ studyName } - New Report"

Template.reportForm.events
  'change .file-upload': (evt)->
    timeout = 10000
    interval = window.setInterval(()->
      # The event target will not be in the template once the file is added.
      if not $.contains(document, evt.target) or timeout <= 0
        currentDoc = AutoForm.getFormValues("ranavirus-report").insertDoc
        utils.subscribeToDocFiles(currentDoc)
        window.clearInterval(interval)
      timeout -= 1000
    , 1000)

  'click .review-panel-header': ()->
    $(".review-content").toggle()

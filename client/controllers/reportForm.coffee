getCollections = => @collections
contactFromUser = @contactFromUser

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
      editPath = Router.path 'editReport', {reportId: @docId}
      toastr.success("""
      <div>#{operation} successful!</div>
      <a href="#{editPath}">Edit Report</a>
      """)
      window.scrollTo(0, 0)
      if template.data.redirectOnSubmit
        Router.go template.data.redirectOnSubmit
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

Template.registerHelper 'reportDoc', () =>
  if Template.currentData().report
      Template.currentData().report
    else
      study = _.extend Template.currentData().study, { studyId: Template.currentData().study._id }
      contactFromUser = @contactFromUser()
      @mergeObjects study.contact, contactFromUser
      study

Template.reportFormComplete.helpers

  isInsert: ->
    Template.currentData().type == 'insert'

  isUpdate: ->
    Template.currentData().type == 'update'

  studyId: ->
    studyId: @study._id

Template.reportFormObfuscated.helpers
  studyId: ->
    studyId: @study._id

Template.reportFormComplete.events

  'click .review-panel-header': (e)->
    $(e.target).toggleClass('showing')
    $('.review-content').toggleClass('hidden-panel')
    $('.page-wrap').toggleClass('curtain')

Template.reportFormComplete.created = () ->
  $('#ranavirus-report').hide()
  reset = () ->
    AutoForm.resetForm('ranavirus-report')
    $('#ranavirus-report').show()
  setTimeout reset, 0

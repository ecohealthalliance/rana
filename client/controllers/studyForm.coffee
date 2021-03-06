getCollections = () -> @collections

Template.studyFormComplete.helpers

  studyId: ->
    studyId: @study._id

  redirectOnSubmit: ->
    editPath = Router.path 'editStudy', {studyId: @study._id}
    "redirectOnSubmit=#{editPath}"

  studyDoc: =>
    Template.currentData()?.study or { contact: @contactFromUser() }

Template.studyFormObfuscated.helpers

  studyDoc: =>
    Template.currentData()?.study

AutoForm.hooks
  'ranavirus-study':

    formToDoc: (doc) ->
      doc.createdBy =
        userId: Meteor.userId()
        name: Meteor.user().profile?.name or "None"
      doc

    onSuccess: (operation, result, template) ->
      toastr.remove()
      toastr.options =
        closeButton: true
        positionClass: "toast-bottom-center"
        timeOut: "100000"
        # This is the timeout after a mouseover event
        extendedTimeOut: "100000"
      editPath = Router.path 'editStudy', {studyId: @docId}
      toastr.success("""
      <div>#{operation} successful!</div>
      <a href="#{editPath}">Edit Study</a>
      """)
      reportFormPath = Router.path 'newReport', {studyId: @docId}
      importReportsPath = Router.path 'importReports', {studyId: @docId}
      toastr.info("""
      <div>Please add reports about the Ranavirus cases in this study.</div>
      You can <a href="#{reportFormPath}">add individual reports via form</a>
      or <a href="#{importReportsPath}">import a csv</a> with multiple reports.
      """)
      if template.data.redirectOnSubmit
        Router.go template.data.redirectOnSubmit
      else
        window.scrollTo(0, 0)
        $('#ranavirus-study').show()

    onError: (operation, error) ->
      toastr.remove()
      errorLocation = $("""[data-schema-key="#{error.invalidKeys[0].name}"]""")
        .parent()
        .offset()
        ?.top
      window.scrollTo(0, errorLocation) if errorLocation
      toastr.options = {
        closeButton: true
        positionClass: "toast-bottom-center"
        timeOut: "100000"
        extendedTimeOut: "100000"
      }
      toastr.error(error.message)

popoverOpts =
  trigger: 'hover'
  placement: 'bottom auto'
  container: 'body'
  viewport:
    selector: 'body'
    padding: 10
  animation: true
  delay:
    show: 350
    hide: 100

Template.studyFormComplete.created = () ->
  $('#ranavirus-study').hide()
  reset = () ->
    AutoForm.resetForm('ranavirus-study')
    $('#ranavirus-study').show()
    $($('.leaflet-container')[0]).data('map').invalidateSize()
    @$('[data-toggle="popover"]').popover popoverOpts
  setTimeout reset, 0

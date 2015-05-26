getCollections = () -> @collections

Template.studyFormComplete.helpers

  studyId: ->
    studyId: @study._id

  redirectOnSubmit: ->
    editPath = Router.path 'editStudy', {studyId: @study._id}
    "redirectOnSubmit=#{editPath}"

  studyDoc: =>
    Template.currentData()?.study or { contact: @contactFromUser() }

  showCSV: ->
    not Template.currentData().study

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
      if template.data.redirectOnSubmit
        Router.go template.data.redirectOnSubmit
      else
        window.scrollTo(0, 0)
        $('#ranavirus-study').show()

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

    after:
      insert: (err, res, template) =>

        Meteor.subscribe "studies", res, () =>
          study = getCollections().Studies.findOne { _id: res }

          if study and study.csvFile
            @loadCSVData study.csvFile, study, res

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
    @$('[data-toggle="popover"]').popover popoverOpts
  setTimeout reset, 0

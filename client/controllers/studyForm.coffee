getCollections = () -> @collections

Template.studyForm.helpers

  importDoc: () =>
    { contact: @contactFromUser() }

AutoForm.hooks
  'ranavirus-import':

    docToForm: (doc, ss)->
      if doc
        utils.subscribeToDocFiles(doc)
      return doc

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
      toastr.success("""
      <div>#{operation} successful!</div>
      <a href="/study/#{@docId}">Edit Study</a>
      """)
      window.scrollTo 0, 0

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

        study = getCollections().Studies.findOne { _id: res }

        if study and study.csvFile
          @loadCSVData study.csvFile, study, res

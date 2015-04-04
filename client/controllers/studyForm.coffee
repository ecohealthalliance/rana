getCollections = () -> @collections



Template.studyForm.helpers

  studyDoc: =>
    urlParams = Iron.controller().getParams()
    if urlParams?.studyId
      return getCollections().Studies.findOne(urlParams.studyId) or {}
    else
      { contact: @contactFromUser() }

  type: ->
    urlParams = Iron.controller().getParams()
    if not urlParams?.studyId
      return "insert"
    currentStudy = getCollections().Studies.findOne(urlParams.studyId)
    if not currentStudy
      # This will trigger an error message
      return null
    if Meteor.userId() and Meteor.userId() == currentStudy.createdBy.userId
      return "update"
    return "readonly"

  showCSV: ->
    not Iron.controller().getParams()?.studyId


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
      message = """<div>#{operation} successful!</div>"""
      # don't show link to update if we have just updated
      if operation is 'insert'
        message += """<a href="/study/#{result}">Edit Study</a>"""
      toastr.success message
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
      insert: (err, res, template) ->

        study = getCollections().Studies.findOne { _id: res }

        if study and study.csvFile

          Meteor.call 'getCSVData', study.csvFile, (err, data) =>
            reportSchema = getCollections().Reports.simpleSchema()._schema
            reportFields = Object.keys reportSchema
            studyData = {}
            for studyField in Object.keys study
              if studyField != '_id' and studyField in reportFields
                studyData[studyField] = _.clone study[studyField]

            for row in data
              report = {}
              for key of studyData
                report[key] = _.clone studyData[key]
              for reportField in reportFields
                if reportField of row and row[reportField]
                  report[reportField] = row[reportField]
              report.createdBy =
                userId: Meteor.user()._id
                name: Meteor.user().profile.name
              report.studyId = res
              getCollections().Reports.insert report

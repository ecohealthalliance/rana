getCollections = () -> @collections

Template.studyForm.helpers

  importDoc: () =>
    { contact: @contactFromUser() }

AutoForm.hooks
  'ranavirus-import':

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
      <a href="/study/#{result}">Edit Study</a>
      """)
      clearImportReports()
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
              @collections.Reports.insert report

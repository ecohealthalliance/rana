getCollections = () -> @collections

ImportReports = null
Meteor.startup () ->
  ImportReports = new Mongo.Collection null
  ImportReports.attachSchema @reportSchema

fileUploaded = () ->
  checkUploaded = () ->
    fileId = Session.get 'fileUpload[csvFile]'
    if fileId
      record = @collections.CSVFiles.findOne { _id: fileId }
      if record and record.isUploaded()
        return Meteor.call 'getCSVData', fileId, (err, data) =>
          if data
            updateImportReports data
          else
            setTimeout checkUploaded, 10
    setTimeout checkUploaded, 10

  checkUploaded()

clearImportReports = () ->
  ImportReports.remove({})
  Session.set 'unmatchedHeaders', null

updateImportReports = (data) ->

  clearImportReports()
  matches = headerMatches(data).matched

  for row in data
    # Fake contact data to satisfy requirement
    rowdata =
      studyId: 'fakeid'
      contact:
        name: 'fake'
        email: 'a@b.com'
        phone: '1234567890'
      createdBy:
        userId: Meteor.user()._id
        name: Meteor.user().profile.name
    for field in matches
      rowdata[field] = row[field]
    ImportReports.insert rowdata

headerMatches = (data) ->
  headers = _.keys data[0]
  fields = Object.keys @collections.Reports.simpleSchema()._schema

  res =
    matched: ( header for header in headers when header in fields )
    unmatched: ( header for header in headers when header not in fields )

  Session.set 'unmatchedHeaders', res.unmatched

  res

Template.studyForm.events
  'change .file-upload': (e, t) ->

    fileUploaded()

  'click .file-upload-clear': (e, t) ->

    if $(e.currentTarget).attr('file-input') is 'csvFile'
      clearImportReports()
      Session.set 'fileUpload[csvFile]', false

Template.studyForm.helpers

  importDoc: () ->
    { contact: UI._globalHelpers['contactFromUser']() }

  csvFileId: () ->
    Session.get 'fileUpload[csvFile]'

  csvFileName: () ->
    fileId = Session.get 'fileUpload[csvFile]'
    if fileId
      getCollections().CSVFiles.findOne({ _id: Session.get 'fileUpload[csvFile]' }).original.name
    else
      null

  importReports: () ->
    ImportReports.find()

  importFields: () ->
    data = ImportReports.findOne()
    if data
      res = ( field for field in [ 'eventDate', 'coordinatesAvailable', 'eventLocation', 'eventCountry',
          'numInvolved', 'totalAnimalsTested', 'totalAnimalsConfirmedInfected',
          'totalAnimalsConfirmedDiseased', 'populationType', 'screeningReason',
          'speciesGenus', 'speciesName', 'speciesNotes', 'sampleType',
          'additionalNotes' ] when field of data
      )
      res
    else
      []

  unmatchedHeadersString: () ->
    Session.get('unmatchedHeaders').join ', '

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
        positionClass: "toast-top-center"
        timeOut: "10000"
      toastr.success operation + " successful!"
      clearImportReports()
      window.scrollTo 0, 0

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

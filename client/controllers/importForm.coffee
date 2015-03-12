getCollections = () -> @collections

ImportReports = null
Meteor.startup () ->
  ImportReports = new Mongo.Collection null
  ImportReports.attachSchema @reportSchema

fileUploaded = () ->
  checkUploaded = () ->
    fileId = Session.get 'fileUpload[csvFile]'
    isUploaded = false
    if fileId
      record = @collections.CSVFiles.findOne { _id: fileId }
      if record and record.isUploaded()
        return Meteor.call 'getCSVData', fileId, (err, data) =>
          Session.set 'csvData', data
          if data
            updateImportReports data
          else
            setTimeout checkUploaded, 10

    setTimeout checkUploaded, 10

  checkUploaded()

clearImportReports = () ->
  ImportReports.remove({})

updateImportReports = () ->

  ImportReports
  clearImportReports()
  matches = headerMatches().matched

  csvData = Session.get 'csvData'

  if csvData and csvData.length > 0

    for row in csvData
      # Fake contact datato satisfy requirement
      rowdata = { 'contact': {'name': 'fake', 'email': 'a@b.com', 'phone': '1234567890'} }
      for field in matches
        rowdata[field] = row[field]
      ImportReports.insert rowdata

getHeaders = () ->
  csvData = Session.get 'csvData'
  if csvData and csvData.length > 0
    Object.keys Session.get('csvData')[0]
  else
    []

headerMatches = () ->
  headers = getHeaders()
  fields = Object.keys @collections.Reports.simpleSchema()._schema

  res =
    matched: ( header for header in headers when header in fields )
    unmatched: ( header for header in headers when header not in fields )

  res

Template.importForm.events
  'change .file-upload': (e, t) ->

    fileUploaded()

  'click .file-upload-clear': (e, t) ->

    if $(e.currentTarget).attr('file-input') is 'csvFile'
      clearImportReports()
      Session.set 'csvData', []
      Session.set 'fileUpload[csvFile]', false

Template.importForm.helpers

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
    csvData = Session.get 'csvData'
    if csvData and csvData.length > 0
      res = ( field for field in [ 'eventDate', 'coordinatesAvailable', 'eventLocation', 'eventCountry',
          'numInvolved', 'totalAnimalsTested', 'totalAnimalsConfirmedInfected',
          'totalAnimalsConfirmedDiseased', 'populationType', 'screeningReason',
          'speciesGenus', 'speciesName', 'speciesNotes', 'sampleType',
          'additionalNotes' ] when field of csvData[0]
      )
      res
    else
      []

  unmatchedHeadersString: () ->
    headerMatches().unmatched.join ', '

AutoForm.hooks
  importForm:
    after:
      insert: (err, res, template) ->

        clearImportReports()

        study = getCollections().Studies.findOne({_id: res})

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
            getCollections().Reports.insert report
getCollections = () -> @collections

ImportReports = null
Meteor.startup () ->
  ImportReports = new Mongo.Collection null
  ImportReports.attachSchema @reportSchema

fileUploaded = (template) ->
  checkUploaded = () ->
    fileId = Session.get 'fileUpload[csvFile]'
    if fileId
      record = @collections.CSVFiles.findOne { _id: fileId }
      if record and record.isUploaded()
        return Meteor.call 'getCSVData', fileId, (err, data) =>
          if err
            template.csvError.set err.reason
            Session.set 'fileUpload[csvFile]', false
          else if data
            template.csvError.set null
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
      consent: true
      dataUsePermissions: 'Share obfuscated'
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

Template.csvUpload.events
  'change .file-upload': (e, t) ->
    Session.set 'csvError', null
    fileUploaded(Template.instance())

  'click .file-upload-clear': (e, t) ->

    if $(e.currentTarget).attr('file-input') is 'csvFile'
      clearImportReports()
      Session.set 'fileUpload[csvFile]', false

Template.csvUpload.helpers

  csvError: () ->
    UI._templateInstance().csvError.get() or ''

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

Template.csvUpload.created = ->
  @csvError = new ReactiveVar
  @csvError.set(null)

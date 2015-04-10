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

getReportFieldType = (field) ->
  reportSchema = getCollections().Reports.simpleSchema()._schema

  if field not of reportSchema
    null
  else
    reportSchema[field].type

updateImportReports = (data) ->

  clearImportReports()
  matches = headerMatches(data).matched

  for row in data

    report = buildReportFromImportData row, report

    report.studyId = 'fakeid'
    report.createdBy =
      userId: Meteor.user()._id
      name: Meteor.user().profile.name

    if 'contact' not in report
      report.contact =
        name: 'fake'
        email: 'a@b.com'
        phone: '1234567890'
    if 'consent' not in report
      report.consent = true
    if 'dataUsePermissions' not in report
      report.dataUsePermissions = 'Share obfuscated'

    ImportReports.insert report

buildReportFromImportData = (importData, report) ->

  report = {}

  # contact
  contact = {}
  for field in ['name', 'email', 'phone']
    key = 'contact.' + field
    if key of importData
      contact[field] = importData[key]
  institutionAddress = {}
  for field in ['name', 'street', 'street2', 'city', 'stateOrProvince', 'country', 'postalCode']
    key = 'contact.institutionAddress.' + field
    if key of importData
      institutionAddress[field] = importData[key]
  if Object.keys(institutionAddress).length > 0
    contact.institutionAddress = institutionAddress
  if Object.keys(contact).length > 0
    report.contact = contact

  # eventLocation
  if ( 'eventLocation.longitude' of importData and
       'eventLocation.latitude' of importData )
    country = importData['eventLocation.country']
    lon = parseFloat importData['eventLocation.longitude']
    lat = parseFloat importData['eventLocation.latitude']
    utm = Mapping.utmFromLonLat lon, lat
    report['eventLocation'] =
      source: 'LonLat'
      northing: utm.northing
      easting: utm.easting
      zone: utm.zone
      country: country
      geo:
        type: 'Point'
        coordinates: [lon, lat]
  else if ( 'eventLocation.easting' of importData and
            'eventLocation.northing' of importData and
            'eventLocation.zone' of importData)
    country = importData['eventLocation.country']
    easting = importData['eventLocation.easting']
    northing = importData['eventLocation.northing']
    zone = importData['eventLocation.zone']
    coords = Mapping.lonLatFromUTM easting, northing, zone
    report['eventLocation'] =
      source: 'LonLat'
      northing: northing
      easting: easting
      zone: zone
      country: country
      geo:
        type: 'Point'
        coordinates: [coords.lon, coords.lat]

  for field of importData

    if '.' not in field
      fieldType = getReportFieldType field
      if fieldType
        value = importData[field]
        if fieldType is Array
          if field is 'genBankAccessionNumbers'
            report[field] = _.map(value.split(','), (val) ->
              { genBankAccessionNumber: val }
            )
          else
            report[field] = value.split ','
        else if fieldType is Boolean
          report[field] = value is 'true'
        else if fieldType is Date
          report[field] = Date.parse(value)
        else
          report[field] = value

  report

@loadCSVData = (csvFile, study, studyId) ->
  Meteor.call 'getCSVData', csvFile, (err, data) =>
    reportSchema = getCollections().Reports.simpleSchema()._schema
    reportFields = Object.keys reportSchema
    report = {}
    for studyField in Object.keys study
      if studyField != '_id' and studyField in reportFields
        report[studyField] = _.clone study[studyField]

    for importData in data
      importReport = buildReportFromImportData importData, report
      _.extend report, importReport
      report.createdBy =
        userId: Meteor.user()._id
        name: Meteor.user().profile.name
      report.studyId = studyId
      getCollections().Reports.insert report


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
  clearImportReports()
  @csvError = new ReactiveVar
  @csvError.set(null)

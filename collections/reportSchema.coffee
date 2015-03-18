@reportSchema = new SimpleSchema [ @sharedSchema, new SimpleSchema
  studyId:
    type: String
    autoform:
      template: 'studySelect'
  sourceFile:
    label: """The id of the CSV file from which the event was imported, if any"""
    type: String
    optional: true
    autoform:
      type: 'hidden'
      label: false
  contact:
    type: @contactSchema
   eventDate:
    label: 'Event date'
    type: Date
    optional: true
  eventLocation:
    label: 'Event Location'
    type: String
    optional: true
    autoform:
      type: 'leaflet'
      afFieldInput:
        type: 'leaflet'
  eventCountry:
    label: 'Event Country'
    type: String
    optional: true
  numInvolved:
    label: """Estimated Number of Individuals Involved in the Mortality Event"""
    type: String
    optional: true
    autoform:
      afFieldInput:
        options: _.map(@numInvolvedOptions, (definition, option)-> {label:definition, value: option})
  totalAnimalsTested:
    label: 'Total Number of Animals Tested'
    type: Number
    optional: true
  totalAnimalsConfirmedInfected:
    label: 'Total Number of Animals Confirmed Infected'
    type: Number
    optional: true
  totalAnimalsConfirmedDiseased:
    label: 'Total Number of Animals Confirmed Diseased'
    type: Number
    optional: true
  pathologyReports:
    type: Array
    optional: true
  'pathologyReports.$':
    type: Object
    optional: true
  'pathologyReports.$.report':
    type: String
    label: ''
    optional: true
    autoform:
      afFieldInput:
        type: 'fileUpload'
        collection: 'files'
  'pathologyReports.$.permission':
    label: "Do you have permission to upload this report?"
    type: String
    allowedValues: ["Yes", "Permission Not Granted", "Not Available or Applicable"]
    autoform:
      afFieldInput:
        noselect: true
  # We are skipping the N/A tick boxes
  # because the user can leave the sections blank instead.
  images:
    type: Array
    optional: true
    label: ''
  'images.$':
    type: Object
    autoform:
      template: 'noLabel'
  'images.$.image':
    type: String
    autoform:
      afFieldInput:
        type: 'fileUpload'
        collection: 'files'
  genBankAccessionNumbers:
    type: Array
    optional: true
    label: ''
  'genBankAccessionNumbers.$':
    type: Object
    autoform:
      template: 'noLabel'
  'genBankAccessionNumbers.$.genBankAccessionNumber':
    type: String
]

numInvolvedOptions =
  '1': '1'
  '2_10': '2 to 10'
  '11_50': '11 to 50'
  '51_100': '51 to 100'
  '101_500': '101 to 500'
  '500_': 'more than 500'

@reportSchema = new SimpleSchema [ @sharedSchema, new SimpleSchema
  studyId:
    type: String
    autoform:
      type: 'hidden'
      label: false
  csvFile:
    type: String
    label: """csvFile"""
    optional: true
    autoform:
      label: false
      afFieldInput:
        type: 'fileUpload'
        collection: 'csvfiles'
  contact:
    type: @contactSchema
  #eventCountry:
    #label: 'Event Country'
    #type: String
    #optional: true
  numInvolved:
    label: 'Number Involved'
    type: String
    optional: true
    autoform:
      afFieldInput:
        options: _.map(numInvolvedOptions, (definition, option)-> {label:definition, value: option})
      tooltip: 'Estimated Number of Individuals Involved in the Mortality Event'
  totalAnimalsTested:
    label: 'Total Number of Animals Tested'
    type: Number
    optional: true
    autoform:
      tooltip: """The total number of animals tested for the presence of the ranavirus
        for the event being reported. Please note that this is per species."""
  totalAnimalsConfirmedInfected:
    label: 'Total Number of Animals Confirmed Infected'
    type: Number
    optional: true
    autoform:
      tooltip: """The total number of animals confirmed to be infected
        with the ranavirus through diagnostic tests with positive results for the event
        and species currently being reported."""
  totalAnimalsConfirmedDiseased:
    label: 'Total Number of Animals Confirmed Diseased'
    type: Number
    optional: true
    autoform:
      tooltip: """The total number of animals having signs of disease consistent
        with ranavirus infection by a certified pathologist AND the individual
        has tested positively for the pathogen during specific diagnostic testing."""
  pathologyReports:
    type: Array
    optional: true
    autoform:
      tooltip: """You can upload (MS Word or PDF) copies of pathology reports for other users to view.
        Please ensure that you have the permission of the pathologist to do this BEFORE you upload any documents.
        If no pathology report is available or permission has not been granted for the pathology report to be uploaded, please indicate this."""
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
  'pathologyReports.$.notified':
    label: "Has the pathologist or laboratory that authored the report been notified that it is being uploaded?"
    type: String
    allowedValues: ["Yes", "No"]
    autoform:
      afFieldInput:
        noselect: true
  # We are skipping the N/A tick boxes
  # because the user can leave the sections blank instead.
  images:
    type: Array
    optional: true
    label: ''
    autoform:
      tooltip: """Images from mortality events or of lesions on individual animals from
        the mortality event being reported can be shared here.
        Please do not share images that you do not want other users to see and/or potentially use."""
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
    autoform:
      tooltip: """Please provide the
        GenBank Accession numbers of the sequences associated with the current event being
        reported if they are available."""
  'genBankAccessionNumbers.$':
    type: Object
    autoform:
      template: 'noLabel'
  'genBankAccessionNumbers.$.genBankAccessionNumber':
    type: String
  approval:
    type: String
    allowedValues: ['pending', 'rejected', 'approved']
    defaultValue: 'pending'
    autoform:
      type: 'hidden'
      label: false
]

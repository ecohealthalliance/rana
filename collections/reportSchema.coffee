@reportSchema = new SimpleSchema [ @sharedSchema, new SimpleSchema
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
    label: """
    Enter the date when the ranavirus event being reported occurred or was discovered.
    This may be the date that carcasses were collected.
    If this date is unavailable or unknown, then the date that the diagnostic tests were performed can be used.
    """
    type: Date
    optional: true
  coordinatesAvailable:
    type: Boolean
    label: """
    Do you have the coordinates where the carcasses were collected?
    """
    optional: true
    autoform:
       type: 'boolean-radios'
       trueLabel: 'Yes'
       falseLabel: 'No'
  eventLocation:
    label: """
    Where were the carcasses actually collected or animals sampled?
    Please provide the highest resolution data possible using (UTM or DD coordinates).
    """
    type: String
    optional: true
    autoform:
      type: 'map'
      afFieldInput:
        type: 'map'
        geolocation: true
        searchBox: true
        autolocate: true
  eventCountry:
    label: """
    Please provide the country where the event occurred.
    """
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
    label: """
    Total Number of Animals Tested:
    The total number of animals tested for the presence of the ranavirus
    for the event being reported. Please note that this is per species.
    """
    type: Number
    optional: true
  totalAnimalsConfirmedInfected:
    label: """
    Total Number of Animals Confirmed Infected:
    The total number of animals confirmed to be infected
    with the ranavirus through diagnostic tests with positive results for the event
    and species currently being reported.
    """
    type: Number
    optional: true
  totalAnimalsConfirmedDiseased:
    label: """
    Total Number of Animals Confirmed Diseased:
    The total number of animals having signs of disease consistent
    with ranavirus infection by a certified pathologist AND the individual
    has tested positively for the pathogen during specific diagnostic testing.
    """
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
    label: """
    You can upload (MS Word or PDF) copies of pathology reports for other users to view.
    Please ensure that you have the permission of the pathologist to do this BEFORE you upload any documents.
    If no pathology report is available or permission has not been granted for the pathology report to be uploaded, please indicate this.
    """
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
    label: """
    Images from mortality events or of lesions on individual animals from
    the mortality event being reported can be shared here.
    Please do not share images that you do not want other users to see and/or potentially use.
    """
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
    label: () -> Spacebars.SafeString """
    Please provide the
    <a href="http://www.ncbi.nlm.nih.gov/genbank/" target="_blank">GenBank</a>
    Accession numbers of the sequences associated with the current event being
    reported if they are available.
    """
  'genBankAccessionNumbers.$':
    type: Object
    autoform:
      template: 'noLabel'
  'genBankAccessionNumbers.$.genBankAccessionNumber':
    type: String
]

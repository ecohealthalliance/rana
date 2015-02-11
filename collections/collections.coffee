@collections = {}

@collections.Images = new FS.Collection("images",
  stores: [new FS.Store.GridFS("images", {})]
)

@collections.Files = new FS.Collection("files",
  stores: [new FS.Store.GridFS("files", {})]
)

populationTypes =
  wild:	"""
  Wild: Animals living in the natural environment, this includes lakes, ponds, garden ponds, rivers etc. Animals living in this type of environment may or may not be subject to active management.
  """
  zoological:	"""
  Zoological Facility: Animals held in a managed collection (including private collections). Animals in this category may be for display, maintaining a breeding colony and/or as part of a reintroduction effort.  May also include animals originally collected from the wild.
  """
  production:	"""
  Production Facility: Animals from any facility where the purpose is for food production, sale (e.g. ornamental species) or for sale as laboratory animals. These facilities typically produce large numbers of animals at high densities. Examples: Ranaculture or Aquaculture Facilities. This includes wild animals that may naturally colonize these facilities.
  """
screeningReasons =
  mortality: """
  Mortality: Any event where ranaviral disease or infection is associated with animal death either through disease or other natural processes. May involve as few as one individual to as many as hundreds.
  """
  routine: "Routine Disease Surveillance"

vertebrateClasses =
  fish:	'Fish'
  amphibian:	'Amphibian'
  reptile:	'Reptile (turtles and tortoises, crocodilians, snakes and lizards)'

numInvolvedOptions =
  '1': '1'
  '2_10':	'2 to 10'
  '11_50':	'11 to 50'
  '51_100':	'51 to 100'
  '101_500':	'101 to 500'
  '500_':	'more than 500'

ageClasses =
  'Egg': """
  Egg:
  Includes samples from early embryonic development in the case of amphibians.
  """
  'Larvae/Hatchling': """
  Larvae/Hatchling:
  Early developmental stages after hatching from the egg or egg jelly
  but before they are conventionally considered to be juveniles,
  meaning that they retain larval/hatchling characteristics.
  """
  'Juvenile': """
  Juvenile:
  Animals that have grown beyond the larval/hatchling stage, resembling adults,
  but are not yet sexually mature. In the case of amphibians,
  this would include individuals in which the forelimbs have emerged.
  """
  'Adult': """
  Adult:
  Any sexually mature animal.
  It does not have to have achieved the maximum adult size.
  """
ranavirusConfirmMethods =
  'Traditional PCR': """
  Traditional PCR:
  Polymerase chain reaction assay where the products are quantified using gel electrophoresis.
  """
  'Quantitative Real Time PCR': """
  Quantitative Real Time PCR:
  Polymerase chain reaction assay where the amount of product is measured throughout the assay.
  Often referred to as TaqMan PCR.
  """
  'Virus Isolation': """
  Virus Isolation:
  Ranavirus particles were isolated from infected tissue,
  grown in tissue culture and the cytopathic effect observed in the cells.
  The cells were then subsequently harvested and the presence of
  ranavirus virions was confirmed through other methods
  (e.g. PCR or electron microscopy).
  """
  'Sequencing': """
  Sequencing:
  After the presence of the ranavirus is determined,
  analysis of the viral sequence is performed and the sequences
  are similar to one or more ranavirus isolates available on GenBank.
  """
  'Electron Microscopy': """
  Electron Microscopy:
  The presence of pox-like
  (i.e. icosahedral virus particles)
  particles in tissue samples taken directly from an infected animal
  or samples of virus isolate obtained through virus isolation and culture.
  """
  #TODO: Definition in progress?
  'In Situ Hybridization': """
  In Situ Hybridization
  """
  #TODO: Definition in progress?
  'Immunohistochemistry': """
  Immunohistochemistry
  """
  'other': """
  Other:
  Any other molecular diagnostic tests, not listed here (e.g. ELISA or LUMINEX)
  that has been shown to be a reliable method for determining the presence of live
  or preserved ranavirus particles.
  """

sampleTypes =
  internalSwabs: """
  Internal Swabs:
  A wet or dry swab taken from a body cavity, either during necropsy or during
  routine sampling. Internal swabs include oropharyngeal swabs, rectal swabs,
  swabs taken from the lumen or surface of the internal organs.
  """
  externalSwabs: """
  External Swabs:
  A wet or dry swab taken from the epidermal surfaces exposed to the external environment.
  """
  internalOrganTissues: """
  Internal Organ Tissues:
  Any portion of an internal organ that is used for analytical tests or virus isolation.
  Common tissues used for ranavirus screening and isolation are liver, kidney and spleen samples.
  """
  tailToeClips: """
  Tail/Toe Clips:
  Skin, bone and blood obtained from the removal of a portion (or entire) digit or of the tail.
  """
  blood: """
  Blood:
  Blood obtained during a necropsy or from a live animal, uncontaminated by other tissue types.
  """
  other: """
  Other:
  Any other type of sample not listed here. Please specify.
  """

AddressSchema = new SimpleSchema(
  'name':
    type: String
  'street':
    type: String
  'street2':
    type: String,
    optional: true
  'city':
    type: String
  'stateOrProvince':
    type: String
  'country':
    type: String
  'postalCode':
    type: String
    label: "ZIP"
    regEx: /^[0-9]+$/
)

@collections.Reports = new Mongo.Collection('reports')
@collections.Reports.attachSchema(new SimpleSchema(
  name:
    label: """
    Enter the name of the person who is reporting the case.
    They must be willing to communicate about the case if so requested.
    """
    type: String
  email:
    label: """
    Enter the most current email address or permanent email address of the person reporting the case.
    """
    type: String
    regEx: SimpleSchema.RegEx.Email
    autoform:
      type: "email"
  phone:
    label: """
    Enter the institutional telephone number of the individual who is reporting the case:
    (This must include the country code.)
    """
    type: String
    autoform:
      type: "tel"
  institutionAddress:
    label: """
    Enter the name and full address of the institution,
    diagnostic lab or government agency of the person that is reporting the current case.
    """
    type: AddressSchema
    optional: true
  eventDate:
    label: """
    Enter the date when the ranavirus event being reported occurred or was discovered.
    This may be the date that carcasses were collected.
    If this date is unavailable or unknown, then the date that the diagnostic tests were performed can be used.
    """
    type: Date
    optional: true
  # TODO: I suggest we omit this question.
  # However, there is currently no way to deselect a geopoint, so it might
  # be good for that.
  coordinatesAvailable:
    type: Boolean
    label: """
    Do you have the coordinates where the carcasses were collected?
    """
    optional: true
    autoform:
       type: "boolean-radios"
       trueLabel: "Yes"
       falseLabel: "No"
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
  populationType:
    label: """
    Type of Population:
    """
    type: String
    optional: true
    autoform:
      afFieldInput:
        options: _.map(populationTypes, (definition, option)-> {label:definition, value: option})
        noselect: true
  screeningReason:
    label: """
    Reason for Screening:
    """
    type: String
    optional: true
    autoform:
      afFieldInput:
        options: _.map(screeningReasons, (definition, option)-> {label:definition, value: option})
        noselect: true
  vertebrateClasses:
    type: Array
    optional: true
    autoform:
      options: _.map(vertebrateClasses, (definition, option)-> {label:definition, value: option})
      afFieldInput:
        noselect: true
  "vertebrateClasses.$":
    label: """
    Vertebrate Class(es) Involved
    """
    type: String
    optional: true
    autoform:
      afFieldInput:
        noselect: true
  # TODO: Dropdown is preferred, but we need genus data for that
  speciesGenus:
    label: "Species Affected Genus"
    type: String
    optional: true
  speciesName:
    label: "Species Affected Name"
    type: String
    optional: true
  speciesNotes:
    label: "Species Notes"
    type: String
    optional: true
    autoform:
      rows: 5
  speciesAffectedType:
    type: String
    optional: true
    autoform:
      afFieldInput:
        options: [
          {
            value: 'native'
            label: """
            Native: A species that is found inhabiting its accepted, natural species range.
            """
          }
          {
            value: 'introduced'
            label: """
            Introduced: A species that is present in a geographical area outside of its accepted,
            natural species range. This category would include farmed animals not native to the area.
            """
          }
        ]
        noselect: true
  numInvolved:
    label: """Estimated Number of Individuals Involved in the Mortality Event"""
    type: String
    optional: true
    autoform:
      afFieldInput:
        options: _.map(numInvolvedOptions, (definition, option)-> {label:definition, value: option})
  ageClasses:
    type: Array
    optional: true
    autoform:
      options: _.map(ageClasses, (definition, option)-> {label:definition, value: option})
      afFieldInput:
        noselect: true
  'ageClasses.$':
    label: """
    Age Class(es) Involved
    """
    type: String
    optional: true
    autoform:
      afFieldInput:
        noselect: true
  ranavirusConfirmMethods:
    type: Array
    optional: true
    autoform:
      options: _.map(ranavirusConfirmMethods, (definition, option)-> {label:definition, value: option})
      afFieldInput:
        noselect: true
  'ranavirusConfirmMethods.$':
    label: """Ranavirus Confirmation Method"""
    type: String
    autoform:
      afFieldInput:
        noselect: true
  specifyOtherRanavirusConfirmationMethods:
    type: [String]
    optional: true
    autoform:
      template: 'afFieldValueContains'
      afFieldValueContains:
        name: 'ranavirusConfirmMethods'
        value: 'other'
  # TODO: Maybe this should be a repeated group bc the spec says:
  # The other section would ideally have an input field for text.
  # It would be very useful if there was a way here to incorporate the number of
  # individuals tested and the results. This could be incorporated into
  # the quality score of the data that we hope to develop.
  sampleType:
    type: [String]
    label: 'Type of Sample Used for Ranavirus Confirmation'
    optional: true
    autoform:
      options: _.map(sampleTypes, (definition, option)-> {label:definition, value: option})
      afFieldInput:
        noselect: true
  specifyOtherRanavirusSampleTypes:
    type: [String]
    optional: true
    autoform:
      template: 'afFieldValueContains'
      afFieldValueContains:
        name: 'sampleType'
        value: 'other'
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
        collection: 'images'
  genBankAccessionNumbers:
    type: Array
    optional: true
    label: """
    Please provide the
    <a href="http://www.ncbi.nlm.nih.gov/genbank/" target="_blank">GenBank</a>
    Accession numbers of the sequences associated with the current event being
    reported if they are available.
    """
    autoform:
      template: 'htmlLabel'
  'genBankAccessionNumbers.$':
    type: Object
    autoform:
      template: 'noLabel'
  'genBankAccessionNumbers.$.genBankAccessionNumber':
    type: String
  dataUsePermissions:
    type: String
    label: """
    Please select the information that can be shared with other users.
    """
    autoform:
      options: [
        'Do not share'
        #TODO: Describe what we will obfuscate
        'Share obfuscated'
        'Share full record'
      ].map((value)-> {label:value, value: value})
      afFieldInput:
        noselect: true
  consent:
    type: Boolean
    label: """
    Do you consent to have this data published and made searchable on
    the Ranavirus Reporting System website as per the data use permissions?
    """
    autoform:
       type: 'boolean-radios'
       trueLabel: 'Yes, I consent'
       falseLabel: 'No, I do NOT consent'
  additionalNotes:
    label: """
    List additional information (not previously provided) that describes
    unique features of case (e.g., observations of habitat or husbandry conditions,
    diagnosed presence of other pathogens, observations of gross pathological signs).
    """
    type: String
    optional: true
    autoform:
      rows: 5
  publicationInfo:
    type: Object
    optional: true
  'publicationInfo.dataPublished':
    type: Boolean
    label: 'Publication Status of the Data'
    autoform:
      type: 'boolean-radios'
      trueLabel: 'Published'
      falseLabel: 'Unpublished'
  'publicationInfo.pdf':
    type: String
    label: """
    If the data has been published please provide a PDF.
    """
    # For some reason the optional value on the parent obj doesn't apply to this
    optional: true
    autoform:
      afFieldInput:
        type: 'fileUpload'
        collection: 'files'
  'publicationInfo.reference':
    type: String
    label: """If the data has been published please provide a full reference"""
    optional: true
    autoform:
      rows: 3
  # TODO: Case quality score Assigned internally based on algorithm determined by experts
))

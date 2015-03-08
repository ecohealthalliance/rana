@collections = {}

@collections.Files = new FS.Collection("files",
  stores: [new FS.Store.GridFS("files", {})]
)

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

AddressSchema = new SimpleSchema(
  'name':
    type: String
  'street':
    type: String
    label: 'Street Address'
  'street2':
    type: String,
    label: 'Street Address 2'
    optional: true
  'city':
    type: String
  'stateOrProvince':
    type: String
  'country':
    type: String
  'postalCode':
    type: String
    label: 'Zip'
)

@collections.Reports = new Mongo.Collection('reports')
@collections.Reports.attachSchema(new SimpleSchema(
  name:
    label: "Name"
    type: String
  email:
    type: String
    regEx: SimpleSchema.RegEx.Email
    autoform:
      type: 'email'
  phone:
    label: "Phone Number"
    type: String
    autoform:
      type: 'tel'
  institutionAddress:
    type: AddressSchema
    optional: true
  eventDate:
    label: 'Event date'
    type: Date
    optional: true
  coordinatesAvailable:
    type: Boolean
    label: "Do you have the coordinates where the carcasses were collected?"
    optional: true
    autoform:
       type: 'boolean-radios'
       trueLabel: 'Yes'
       falseLabel: 'No'
  eventLocation:
    label: 'Event Location'
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
        options: [
          { value: 'wild', label: 'Wild' }
          { value: 'zoological', label: 'Zoological' }
          { value: 'production', label: 'Production'}
        ]
        noselect: true
  screeningReason:
    label: """
    Reason for Screening:
    """
    type: String
    optional: true
    autoform:
      afFieldInput:
        options: [
          { value: 'mortality', label: 'Mortality' }
          { value: 'routine', label: 'Routine' }
        ]
        noselect: true
  vertebrateClasses:
    type: Array
    optional: true
    autoform:
      options: [
        { value: 'fish', label: 'Fish' }
        { value: 'amphibian', label: 'Amphibian' }
        { value: 'reptile', label: 'Reptile' }
      ]
      noselect: true
  'vertebrateClasses.$':
    label: """
    Vertebrate Class(es) Involved
    """
    type: String
    optional: true
    autoform:
      afFieldInput:
        noselect: true
  speciesGenus:
    label: 'Species Affected Genus'
    type: String
    optional: true
  speciesName:
    label: 'Species Affected Name'
    type: String
    optional: true
  speciesNotes:
    label: 'Species Notes'
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
          { value: 'native', label: 'Native' }
          { value: 'introduced', label: 'Introduced' }
        ]
        noselect: true
  numInvolved:
    label: 'Estimated Number of Individuals Involved in the Mortality Event'
    type: String
    optional: true
    autoform:
      afFieldInput:
        options: _.map(numInvolvedOptions, (definition, option)-> {label:definition, value: option})
  ageClasses:
    type: Array
    optional: true
    autoform:
      options: [
        { value: 'egg', label: 'Egg' }
        { value: 'larvae', label: 'Larvae/Hatchling' }
        { value: 'juvenile', label: 'Juvenile' }
        { value: 'adult', label: 'Adult' }
      ]
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
      options: [
        { value: 'traditional_pcr', 'label': 'Traditional PCR' }
        { value: 'qrt_pcr', 'label': 'Quantitative Real Time PCR' }
        { value: 'virus_isolation', 'label': 'Virus Isolation' }
        { value: 'sequencing', 'label': 'Sequencing' }
        { value: 'electron_microscopy', 'label': 'Electron Microscopy' }
        { value: 'in_situ_hybridization', 'label': 'In Situ Hybridization' }
        { value: 'immunohistochemistry', 'label': 'Immunohistochemistry' }
        { value: 'other', 'label': 'Other' }
      ]
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
  sampleType:
    type: [String]
    label: 'Type of Sample Used for Ranavirus Confirmation'
    optional: true
    autoform:
      options: [
        { value: 'internal_swabs', label: 'Internal Swabs'}
        { value: 'external_swabs', label: 'External Swabs'}
        { value: 'internal_organ_tissues', label: 'Internal Organ Tissues'}
        { value: 'tail_toe_clips', label: 'Tail/Toe Clips'}
        { value: 'blood', label: 'Blood'}
        { value: 'internal_swabs', label: 'Internal Swabs'}
        { value: 'other', label: 'Other'}
      ]
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
    label: 'Pathology Reports'
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
    label: 'Images'
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
    label: 'GenBack Accession Numbers'
  'genBankAccessionNumbers.$':
    type: Object
    autoform:
      template: 'noLabel'
  'genBankAccessionNumbers.$.genBankAccessionNumber':
    type: String
  dataUsePermissions:
    type: String
    label: 'Data Use Permissions'
    autoform:
      options: [
        'Do not share'
        'Share obfuscated'
        'Share full record'
      ].map((value)-> {label:value, value: value})
      afFieldInput:
        noselect: true
  consent:
    type: Boolean
    label: 'Publication Consent'
    autoform:
       type: 'boolean-radios'
       trueLabel: 'Yes, I consent'
       falseLabel: 'No, I do NOT consent'
  additionalNotes:
    label: 'Additional Notes'
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
    label: 'Publication PDF'
    optional: true
    autoform:
      afFieldInput:
        type: 'fileUpload'
        collection: 'files'
  'publicationInfo.reference':
    type: String
    label: 'Reference'
    optional: true
    autoform:
      rows: 3
))

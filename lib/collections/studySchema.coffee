@studySchema = new SimpleSchema  [ @sharedSchema, new SimpleSchema
  contact:
    type: @contactSchema
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
    label: """If the data has been published please provide a PDF."""
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
  dataUsePermissions:
    type: String
    label: """
    Please select the information that can be shared with other users.
    """
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
    label: """
    Do you consent to have this data published and made searchable on
    the Ranavirus Reporting System website as per the data use permissions?
    """
    autoform:
       type: 'boolean-radios'
       trueLabel: 'Yes, I consent'
       falseLabel: 'No, I do NOT consent'
  csvFile:
    type: String
    label: """csvFile"""
    autoform:
      label: false
      afFieldInput:
        type: 'fileUpload'
        collection: 'csvfiles'

]


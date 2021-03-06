@studySchema = new SimpleSchema  [ @sharedSchema, new SimpleSchema
  name:
    type: String
    label: 'Study Name'
    unique: true
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
        collection: 'pdfs'
  'publicationInfo.reference':
    type: String
    label: """If the data has been published please provide a full reference"""
    optional: true
    autoform:
      rows: 3
]

@studySchema.messages {
  "notUnique name": "A study with that name already exists."
}


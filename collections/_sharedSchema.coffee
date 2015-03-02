@sharedSchema =
  populationType:
    label: """Type of Population:"""
    type: String
    optional: true
    autoform:
      afFieldInput:
        options: _.map(@populationTypes, (definition, option)-> {label:definition, value: option})
        noselect: true
  screeningReason:
    label: """Reason for Screening:"""
    type: String
    optional: true
    autoform:
      afFieldInput:
        options: _.map(@screeningReasons, (definition, option)-> {label:definition, value: option})
        noselect: true
  vertebrateClasses:
    type: Array
    optional: true
    autoform:
      options: _.map(@vertebrateClassesChoices, (definition, option)-> {label:definition, value: option})
      afFieldInput:
        noselect: true
  'vertebrateClasses.$':
    label: """Vertebrate Class(es) Involved"""
    type: String
    optional: true
    autoform:
      afFieldInput:
        noselect: true
  ageClasses:
    type: Array
    optional: true
    autoform:
      options: _.map(@ageClasses, (definition, option)-> {label:definition, value: option})
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
  ranavirusConfirmMethods:
    type: Array
    optional: true
    autoform:
      options: _.map(@ranavirusConfirmMethodsChoices, (definition, option)-> {label:definition, value: option})
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
      options: _.map(@sampleTypes, (definition, option)-> {label:definition, value: option})
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

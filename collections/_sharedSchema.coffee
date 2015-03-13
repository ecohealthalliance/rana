@sharedSchema =
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
  additionalNotes:
    label: 'Additional Notes'
    type: String
    optional: true
    autoform:
      rows: 5
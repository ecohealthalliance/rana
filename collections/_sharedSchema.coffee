@sharedSchema =
  populationType:
    label: "Type of Population"
    type: String
    optional: true
    autoform:
      afFieldInput:
        options: [
          { value: 'wild', label: 'Wild', tooltip: """Animals living in the natural environment, this includes lakes, ponds, garden ponds, rivers etc.
            Animals living in this type of environment may or may not be subject to active management."""}
          { value: 'zoological', label: 'Zoological', tooltip: """Animals held in a managed collection (including private collections).
            Animals in this category may be for display, maintaining a breeding colony and/or as part of a reintroduction effort.
            May also include animals originally collected from the wild.""" }
          { value: 'production', label: 'Production', tooltip: """Animals from any facility where the purpose is for food production,
            sale (e.g. ornamental species) or for sale as laboratory animals. These facilities
            typically produce large numbers of animals at high densities. Examples: Ranaculture or Aquaculture Facilities.
            This includes wild animals that may naturally colonize these facilities.""" }
        ]
        noselect: true
   screeningReason:
    label: "Reason for Screening"
    type: String
    optional: true
    autoform:
      afFieldInput:
        options: [
          { value: 'mortality', label: 'Mortality', tooltip: """Any event where ranaviral disease or infection is associated
            with animal death either through disease or other natural processes. May involve as
            few as one individual to as many as hundreds.""" }
          { value: 'routine', label: 'Routine', tooltip: 'Routine Disease Surveillance' }
        ]
        noselect: true
  vertebrateClasses:
    type: Array
    optional: true
    autoform:
      options: [
        { value: 'fish', label: 'Fish' }
        { value: 'amphibian', label: 'Amphibian' }
        { value: 'reptile', label: 'Reptile', 'tooltip': 'Turtles and tortoises, crocodilians, snakes and lizards' }
        { value: 'other', label: 'Other' }
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
  specifyOtherVertebrateClasses:
    type: [String]
    optional: true
    minCount: 1
    autoform:
      template: 'afFieldValueContains'
      afFieldValueContains:
        name: 'vertebrateClasses'
        value: 'other'
  ageClasses:
    type: Array
    optional: true
    autoform:
      options: [
        { value: 'egg', label: 'Egg', tooltip: 'Includes samples from early embryonic development in the case of amphibians.' }
        { value: 'larvae', label: 'Larvae/Hatchling', tooltip: """Early developmental stages after hatching from the egg or egg jelly
          but before they are conventionally considered to be juveniles,
          meaning that they retain larval/hatchling characteristics.""" }
        { value: 'juvenile', label: 'Juvenile', tooltip: """Animals that have grown beyond the larval/hatchling stage, resembling adults,
          but are not yet sexually mature. In the case of amphibians,
          this would include individuals in which the forelimbs have emerged.""" }
        { value: 'adult', label: 'Adult', tooltip: """Any sexually mature animal. It does not have to have achieved the maximum adult size.""" }
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
  ranaSpecies:
    type: String
    optional: true
    autoform:
      options: [
        { value: 'FV3', label: 'Frog virus 3 (FV3)' }
        { value: 'ATV', label: 'Ambystoma tigrinum virus (ATV)' }
        { value: 'BIV', label: 'Bohle iridovirus (BIV)' }
        { value: 'ECV', label: 'European catfish virus (ECV)' }
        { value: 'SCRV', label: 'Santee-Cooper ranavirus (SCRV)' }
        { value: 'other', label: 'other' }
      ]
  'ranaSpecies.$':
    type: String
    optional: true
    autoform:
      afFieldInput:
        noselect: true
  ranaSpeciesFiles:
    type: Array
    optional: true
    autoform:
      tooltip: """You can upload supporting files for
      the Ranavirus species identification."""
  'ranaSpeciesFiles.$':
    type: Object
    optional: true
  'ranaSpeciesFiles.$.file':
    type: String
    label: ''
    optional: true
    autoform:
      afFieldInput:
        type: 'fileUpload'
        collection: 'files'
  specifyOtherRanaSpecies:
    label: 'Other type'
    type: String
    optional: true
  speciesGenus:
    label: 'Genus'
    type: String
    autoform:
      type: 'genusAutocomplete'
    optional: true
  speciesName:
    label: 'Species'
    type: String
    optional: true
    custom: ()->
      if this.value?.length and not /.+\s.+/.test(this.value) then "notBinomial"
  speciesNotes:
    label: 'Extra notes or comments about the species'
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
          { value: 'native', label: 'Native', tooltip: 'A species that is found inhabiting its accepted, natural species range.' }
          { value: 'introduced', label: 'Introduced', tooltip: 'A species that is present in a geographical area outside of its accepted, natural species range. This category would include farmed animals not native to the area.'}
        ]
        noselect: true
  ranavirusConfirmationMethods:
    type: Array
    optional: true
    autoform:
      options: [
        { value: 'traditional_pcr', label: 'Traditional PCR', tooltip: 'Polymerase chain reaction assay where the products are quantified using gel electrophoresis.' }
        { value: 'qrt_pcr', label: 'Quantitative Real Time PCR', tooltip: """Polymerase chain reaction assay where the amount of product is measured throughout the assay.
          Often referred to as TaqMan PCR.""" }
        { value: 'virus_isolation', label: 'Virus Isolation', tooltip: """Ranavirus particles were isolated from infected tissue,
          grown in tissue culture and the cytopathic effect observed in the cells.
          The cells were then subsequently harvested and the presence of
          ranavirus virions was confirmed through other methods
          (e.g. PCR or electron microscopy).""" }
        { value: 'sequencing', label: 'Sequencing', tooltip: """After the presence of the ranavirus is determined,
          analysis of the viral sequence is performed and the sequences
          are similar to one or more ranavirus isolates available on GenBank.""" }
        { value: 'electron_microscopy', label: 'Electron Microscopy', tooltip: """The presence of pox-like (i.e. icosahedral virus particles)
          particles in tissue samples taken directly from an infected animal
          or samples of virus isolate obtained through virus isolation and culture.""" }
        { value: 'in_situ_hybridization', label: 'In Situ Hybridization', tooltip: """A labeled (generally florescent or color) complementary DNA strand is used to
          highlight the DNA of the pathogen within tissue sections or cells on a glass
          slide for microscopic viewing.""" }
        { value: 'immunohistochemistry', label: 'Immunohistochemistry', tooltip: """A color-labeled antibody is used to highlight the pathogen (antigen) within
          tissue sections on a glass slide for microscopic viewing.""" }
        { value: 'other', label: 'Other', tooltip: """Any other molecular diagnostic tests, not listed here (e.g. ELISA or LUMINEX)
          that has been shown to be a reliable method for determining the presence of live
          or preserved ranavirus particles.""" }
      ]
      afFieldInput:
        noselect: true
  'ranavirusConfirmationMethods.$':
    label: """Ranavirus Confirmation Method"""
    type: String
    autoform:
      afFieldInput:
        noselect: true
  specifyOtherRanavirusConfirmationMethods:
    type: [String]
    optional: true
    minCount: 1
    autoform:
      template: 'afFieldValueContains'
      afFieldValueContains:
        name: 'ranavirusConfirmationMethods'
        value: 'other'
  sampleType:
    type: [String]
    label: 'Type of Sample Used for Ranavirus Confirmation'
    optional: true
    autoform:
      options: [
        { value: 'internal_swabs', label: 'Internal Swabs', tooltip: """A wet or dry swab taken from a body cavity, either during necropsy or during
          routine sampling. Internal swabs include oropharyngeal swabs, rectal swabs,
          swabs taken from the lumen or surface of the internal organs.""" }
        { value: 'external_swabs', label: 'External Swabs', tooltip: """A wet or dry swab taken from the epidermal surfaces exposed to the external environment.""" }
        { value: 'internal_organ_tissues', label: 'Internal Organ Tissues', tooltip: """Any portion of an internal organ that is used for analytical tests or virus
  isolation. Common tissues used for ranavirus screening and isolation are liver, kidney and spleen samples.""" }
        { value: 'tail_toe_clips', label: 'Tail/Toe Clips', tooltip: """Skin, bone and blood obtained from the removal of a portion (or entire) digit or of the tail.""" }
        { value: 'blood', label: 'Blood', tooltip: """Blood obtained during a necropsy or from a live animal, uncontaminated by other tissue types.""" }
        { value: 'other', label: 'Other', tooltip: """Any other type of sample not listed here. Please specify.""" }
      ]
      afFieldInput:
        noselect: true
  specifyOtherRanavirusSampleTypes:
    type: [String]
    optional: true
    minCount: 1
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
      type: "textarea"
      rows: 5
      tooltip: """List additional information (not previously provided) that describes
        unique features of case (e.g., observations of habitat or husbandry conditions,
        diagnosed presence of other pathogens, observations of gross pathological signs)."""
  consent:
    type: Boolean
    label: """
    Do you consent to have this data published and made searchable on
    the Global Ranavirus Reporting System website as per the data use permissions?
    """
    autoform:
       type: 'boolean-radios'
       trueLabel: 'Yes, I consent'
       falseLabel: 'No, I do NOT consent'
  dataUsePermissions:
    type: String
    label: """
    Please select the information that can be shared with other users.
    """
    autoform:
      options: [
        { label: 'Do not share', value: 'Do not share' },
        { label: 'Share obfuscated', value: 'Share obfuscated', tooltip: "Only the report country and the reporter's contact information will be released" }
        { label: 'Share full record', value: 'Share full record' }
      ]
      afFieldInput:
        noselect: true
  creationDate:
    type: Date
    autoform:
      omit: true
    autoValue: ->
      new Date()
  createdBy:
    type: Object
    autoform:
      omit: true
  'createdBy.userId':
    type: String
    autoform:
      omit: true
  # User name is included to avoid querying the user collection for
  # every report.
  # autoValue is not used here because trying to get the user data server-side
  # causes problems, so a hook is used instead.
  'createdBy.name':
    type: String
    autoform:
      omit: true
  eventLocation:
    label: 'Event Location'
    type: @locationSchema
    optional: true
    autoform:
      type: 'leaflet'
      afFieldInput:
        type: 'leaflet'
      tooltip: """Where were the carcasses actually collected or animals sampled?
        Please provide the highest resolution data possible (using UTM or DD coordinates)."""
  eventDate:
    label: 'Event date'
    type: Date
    optional: true
    autoform:
      afFieldInput:
        type: 'date-parse'
      tooltip: """Enter the date when the ranavirus event being reported occurred or was discovered.
        This may be the date that carcasses were collected.
        If this date is unavailable or unknown, then the date that the diagnostic tests were performed can be used."""

SimpleSchema.messages(
  "notBinomial": "Binomial species names are required."
)

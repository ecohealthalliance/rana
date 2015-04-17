@tooltipTexts =
  'contact.name': 'They must be willing to communicate about the case if so requested.'
  email: 'Enter the most current email address or permanent email address of the person reporting the case.'
  phone: 'Enter the institutional telephone number of the individual who is reporting the case, including the country code.'
  institutionAddress: """Enter the name and full address of the institution,
    diagnostic lab or government agency of the person that is reporting the current case."""
  eventDate: """Enter the date when the ranavirus event being reported occurred or was discovered.
    This may be the date that carcasses were collected.
    If this date is unavailable or unknown, then the date that the diagnostic tests were performed can be used."""
  eventLocation: """Where were the carcasses actually collected or animals sampled?
    Please provide the highest resolution data possible using (UTM or DD coordinates)."""
  eventCountry: 'Please provide the country where the event occurred.'
  'native': 'A species that is found inhabiting its accepted, natural species range.'
  introduced: 'A species that is present in a geographical area outside of its accepted, natural species range. This category would include farmed animals not native to the area.'
  "populationType.wild": """Animals living in the natural environment, this includes lakes, ponds, garden ponds, rivers etc.
    Animals living in this type of environment may or may not be subject to active management."""
  "populationType.zoological": """Animals held in a managed collection (including private collections).
    Animals in this category may be for display, maintaining a breeding colony and/or as part of a reintroduction effort.
      May also include animals originally collected from the wild."""
  'populationType.production': """Animals from any facility where the purpose is for food production,
    sale (e.g. ornamental species) or for sale as laboratory animals. These facilities
    typically produce large numbers of animals at high densities. Examples: Ranaculture or Aquaculture Facilities.
    This includes wild animals that may naturally colonize these facilities."""
  'screeningReason.mortality': """Any event where ranaviral disease or infection is associated
    with animal death either through disease or other natural processes. May involve as
    few as one individual to as many as hundreds."""
  'screeningReason.routine': 'Routine Disease Surveillance'
  'vertebrateClasses.reptile': 'Turtles and tortoises, crocodilians, snakes and lizards'
  'ageClasses.egg': 'Includes samples from early embryonic development in the case of amphibians.'
  'ageClasses.larvae': """Early developmental stages after hatching from the egg or egg jelly
    but before they are conventionally considered to be juveniles,
    meaning that they retain larval/hatchling characteristics."""
  'ageClasses.juvenile': """Animals that have grown beyond the larval/hatchling stage, resembling adults,
  but are not yet sexually mature. In the case of amphibians,
  this would include individuals in which the forelimbs have emerged."""
  'ageClasses.adult': """Any sexually mature animal. It does not have to have achieved the maximum adult size."""
  'ranavirusConfirmationMethods.traditional_pcr': """Polymerase chain reaction assay where the products are quantified using gel electrophoresis."""
  'ranavirusConfirmationMethods.qrt_pcr': """Polymerase chain reaction assay where the amount of product is measured throughout the assay.
    Often referred to as TaqMan PCR."""
  'ranavirusConfirmationMethods.virus_isolation': """Ranavirus particles were isolated from infected tissue,
    grown in tissue culture and the cytopathic effect observed in the cells.
    The cells were then subsequently harvested and the presence of
    ranavirus virions was confirmed through other methods
    (e.g. PCR or electron microscopy)."""
  'ranavirusConfirmationMethods.sequencing': """After the presence of the ranavirus is determined,
    analysis of the viral sequence is performed and the sequences
    are similar to one or more ranavirus isolates available on GenBank."""
  'ranavirusConfirmationMethods.electron_microscopy': """The presence of pox-like (i.e. icosahedral virus particles)
    particles in tissue samples taken directly from an infected animal
    or samples of virus isolate obtained through virus isolation and culture."""
  'ranavirusConfirmationMethods.immunohistochemistry': """
    A color-labeled antibody is used to highlight the pathogen (antigen) within
    tissue sections on a glass slide for microscopic viewing.
  """
  'ranavirusConfirmationMethods.in_situ_hybridization': """
  A labeled (generally florescent or color) complementary DNA strand is used to
  highlight the DNA of the pathogen within tissue sections or cells on a glass
  slide for microscopic viewing.
  """
  'ranavirusConfirmationMethods.other': """Any other molecular diagnostic tests, not listed here (e.g. ELISA or LUMINEX)
  that has been shown to be a reliable method for determining the presence of live
  or preserved ranavirus particles."""
  'sampleType.internal_swabs': """A wet or dry swab taken from a body cavity, either during necropsy or during
  routine sampling. Internal swabs include oropharyngeal swabs, rectal swabs,
  swabs taken from the lumen or surface of the internal organs."""
  'sampleType.external_swabs': """A wet or dry swab taken from the epidermal surfaces exposed to the external environment."""
  'sampleType.internal_organ_tissues': """Any portion of an internal organ that is used for analytical tests or virus
  isolation. Common tissues used for ranavirus screening and isolation are liver, kidney and spleen samples."""
  'sampleType.tail_toe_clips': """Skin, bone and blood obtained from the removal of a portion (or entire) digit or of the tail."""
  'sampleType.blood': """Blood obtained during a necropsy or from a live animal, uncontaminated by other tissue types."""
  'sampleType.other': """Any other type of sample not listed here. Please specify."""
  numInvolved: """Estimated Number of Individuals Involved in the Mortality Event"""
  totalAnimalsTested: """The total number of animals tested for the presence of the ranavirus
    for the event being reported. Please note that this is per species."""
  totalAnimalsConfirmedInfected: """The total number of animals confirmed to be infected
    with the ranavirus through diagnostic tests with positive results for the event
    and species currently being reported."""
  totalAnimalsConfirmedDiseased: """The total number of animals having signs of disease consistent
    with ranavirus infection by a certified pathologist AND the individual
    has tested positively for the pathogen during specific diagnostic testing."""
  pathologyReports: """You can upload (MS Word or PDF) copies of pathology reports for other users to view.
    Please ensure that you have the permission of the pathologist to do this BEFORE you upload any documents.
    If no pathology report is available or permission has not been granted for the pathology report to be uploaded, please indicate this."""
  images: """Images from mortality events or of lesions on individual animals from
    the mortality event being reported can be shared here.
    Please do not share images that you do not want other users to see and/or potentially use."""
  genBankAccessionNumbers: """Please provide the
    GenBank Accession numbers of the sequences associated with the current event being
    reported if they are available."""
  additionalNotes: """List additional information (not previously provided) that describes
    unique features of case (e.g., observations of habitat or husbandry conditions,
    diagnosed presence of other pathogens, observations of gross pathological signs)."""
  'publicationInfo.pdf':  'If the data has been published please provide a PDF.'
  'publicationInfo.reference': 'If the data has been published please provide a full reference'
  'speciesAffectedType.native': 'A species that is found inhabiting its accepted, natural species range.'
  'speciesAffectedType.introduced': """A species that is present in a geographical area outside of its accepted,
    natural species range. This category would include farmed animals not native to the area."""
  'dataUsePermissions.share_obfuscated': "only the report country and the reporter's contact information will be released"

Template.reportForm.rendered = () ->
  @$('[data-toggle="tooltip"]').popover({trigger: 'hover'})

Template.studyForm.rendered = () ->
  @$('[data-toggle="tooltip"]').popover({trigger: 'hover'})

minorLabelBlockTexts =
  'eventLocation': 'Please provide the highest resolution data possible using (UTM or DD coordinates).'

Template.registerHelper 'minorLabelBlockText', (name) ->
  console.log 'minorLabelBlockText name', name
  if name of minorLabelBlockTexts
    minorLabelBlockTexts[name]
  else
    false


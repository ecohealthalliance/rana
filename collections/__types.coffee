@populationTypes =
  wild: """
  Wild: Animals living in the natural environment, this includes lakes, ponds, garden ponds, rivers etc. Animals living in this type of environment may or may not be subject to active management.
  """
  zoological:   """
  Zoological Facility: Animals held in a managed collection (including private collections). Animals in this category may be for display, maintaining a breeding colony and/or as part of a reintroduction effort.  May also include animals originally collected from the wild.
  """
  production:   """
  Production Facility: Animals from any facility where the purpose is for food production, sale (e.g. ornamental species) or for sale as laboratory animals. These facilities typically produce large numbers of animals at high densities. Examples: Ranaculture or Aquaculture Facilities. This includes wild animals that may naturally colonize these facilities.
  """
@screeningReasons =
  mortality: """
  Mortality: Any event where ranaviral disease or infection is associated with animal death either through disease or other natural processes. May involve as few as one individual to as many as hundreds.
  """
  routine: 'Routine Disease Surveillance'

@vertebrateClassesChoices =
  fish: 'Fish'
  amphibian:    'Amphibian'
  reptile:  'Reptile (turtles and tortoises, crocodilians, snakes and lizards)'

@numInvolvedOptions =
  'NA': 'Not applicable'
  '1': '1'
  '2_10':   '2 to 10'
  '11_50':  '11 to 50'
  '51_100': '51 to 100'
  '101_500':    '101 to 500'
  '500_':   'more than 500'

@ageClasses =
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
@ranavirusConfirmMethodsChoices =
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
  'In Situ Hybridization': """
  In Situ Hybridization
  """
  'Immunohistochemistry': """
  Immunohistochemistry
  """
  'other': """
  Other:
  Any other molecular diagnostic tests, not listed here (e.g. ELISA or LUMINEX)
  that has been shown to be a reliable method for determining the presence of live
  or preserved ranavirus particles.
  """

@sampleTypes =
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

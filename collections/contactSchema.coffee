@contactSchema = new SimpleSchema
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
      type: 'email'
  phone:
    label: """
    Enter the institutional telephone number of the individual who is reporting the case:
    (This must include the country code.)
    """
    type: String
    autoform:
      type: 'tel'
  institutionAddress:
    label: """
    Enter the full address of the institution,
    diagnostic lab or government agency of the person that is reporting the current case.
    """
    type: @addressSchema
    optional: true
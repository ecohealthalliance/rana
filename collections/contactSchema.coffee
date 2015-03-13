@contactSchema = new SimpleSchema
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
    label: """
    Enter the full address of the institution,
    diagnostic lab or government agency of the person that is reporting the current case.
    """
    type: @addressSchema
    optional: true
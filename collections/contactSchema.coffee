@contactSchema = new SimpleSchema
  name:
    label: "Name"
    type: String
  email:
    type: String
    regEx: SimpleSchema.RegEx.Email
    autoform:
      type: 'email'
      tooltip: 'Enter the most current email address or permanent email address of the person reporting the case.'
  phone:
    label: "Phone Number"
    type: String
    autoform:
      type: 'tel'
      tooltip: 'Enter the institutional telephone number of the individual who is reporting the case, including the country code.'
    optional: true
  institutionAddress:
    type: @addressSchema
    optional: true

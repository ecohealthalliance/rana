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
    optional: true
  institutionAddress:
    type: @addressSchema
    optional: true
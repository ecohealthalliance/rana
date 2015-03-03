@addressSchema = new SimpleSchema
  street:
    type: String
  street2:
    type: String,
    optional: true
  city:
    type: String
  stateOrProvince:
    type: String
  country:
    type: String
  postalCode:
    type: String
    label: 'ZIP'

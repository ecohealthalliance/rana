share.UserProfileSchema = new SimpleSchema
  name: 
    type: String
  phone:
    type: String
    optional: true
  organization:
    type: String
    optional: true
  'organizationStreet':
    type: String
    optional: true
  'organizationStreet2':
    type: String,
    optional: true
  'organizationCity':
    type: String
    optional: true
  'organizationStateOrProvince':
    type: String
    optional: true
  'organizationCountry':
    type: String
    optional: true
  'organizationPostalCode':
    type: String
    label: 'ZIP'
    optional: true

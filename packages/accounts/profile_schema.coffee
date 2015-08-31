share.UserProfileSchema = new SimpleSchema
  name:
    type: String
  organization:
    type: String
    optional: true
    label: 'Organization Name'
  'organizationStreet':
    type: String
    optional: true
    label: 'Address'
  'organizationStreet2':
    type: String,
    optional: true
    label: 'Address 2 (Apt, Floor, Suite)'
  'organizationCity':
    type: String
    optional: true
    label: 'City'
  'organizationStateOrProvince':
    type: String
    optional: true
    label: 'State or Province'
  'organizationPostalCode':
    type: String
    label: 'Zip Code'
    optional: true
  'organizationCountry':
    type: String
    optional: true
    label: 'Country'
  phone:
    type: String
    optional: true

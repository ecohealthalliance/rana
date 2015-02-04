@collections = {}
@collections.Images = new FS.Collection("images",
  stores: [new FS.Store.GridFS("images", {})]
)

@collections.Reports = new Mongo.Collection("reports")
@collections.Reports.attachSchema(new SimpleSchema(
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
  phone:
    label: """
    Enter the institutional telephone number of the individual who is reporting the case:
    """
    type: String
    optional: true
  institutionAddress:
    label: """
    Enter the name and full address of the institution,
    diagnostic lab or government agency of the person that is reporting the current case. 
    """
    type: Object
    optional: true
  'institutionAddress.street': 
    type: String
  'institutionAddress.street2':
    type: String,
    optional: true
  'institutionAddress.city':
    type: String
  'institutionAddress.state':
    type: String
    allowedValues: ["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    autoform:
      afFieldInput:
        firstOption: "(Select a State)"
  'institutionAddress.postalCode':
    type: String
    label: "ZIP"
  location:
    label: """
    Where were the carcasses were actually collected or animals were sampled.
    Please provide the highest resolution data possible using (UTM or DD coordinates).
    """
    type: String
    optional: true
    autoform:
      type: 'map'
      afFieldInput:
        type: 'map'
        geolocation: true
        searchBox: true
        autolocate: true
  pathologyReports:
    type: Array
    optional: true
  'pathologyReports.$':
    type: Object
  'pathologyReports.$.report':
    type: String
    label: """
    You can upload (MS Word or PDF) copies of pathology reports for other users to view.
    Please ensure that you have the permission of the pathologist to do this BEFORE you upload any documents.
    If no pathology report is available or permission has not been granted for the pathology report to be uploaded, please indicate this.
    """
    autoform:
      afFieldInput:
        type: 'fileUpload'
        collection: 'images'
))
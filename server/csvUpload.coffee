getCSVDataHelper = (fileId, userId) =>
  yesterday = new Date()
  yesterday.setDate(yesterday.getDate() - 1);
  record = @collections.CSVFiles.findOne
    _id: fileId
    $or: [
      {owner: userId}
      {
        uploadedAt: { $gte : yesterday }
        owner: { $exists: false }
      }
    ]

  if record?.copies
    csvParseSync = Meteor.wrapAsync CSVParse
    path = @collections.CSVFiles.storesLookup.fs_csvfiles.path
    filename = path + record.copies.fs_csvfiles.key
    fs = Npm.require 'fs'
    csv = fs.readFileSync filename
    try
      csvParseSync csv, { columns: true }
    catch e
      throw new Meteor.Error 500, 'The uploaded file could not be parsed. Please check the format and try again.'
  else
    false

Meteor.methods

  getCSVData: (fileId) ->
    getCSVDataHelper fileId, @userId
Meteor.methods

  getCSVData: (fileId) =>
    record = @collections.CSVFiles.findOne { _id: fileId }
    csvParseSync = Meteor.wrapAsync CSVParse
    path = @collections.CSVFiles.storesLookup.fs_csvfiles.path
    filename = path + record.copies.fs_csvfiles.key

    fs = Npm.require 'fs'
    csv = fs.readFileSync filename
    csvParseSync csv, { columns: true }

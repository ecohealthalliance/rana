# This is only global so it can be initialized in the test fixtures.
@__SpeciesCollection = new Mongo.Collection 'species' 

Meteor.methods

  getCSVData: (fileId) =>
    record = @collections.CSVFiles.findOne { _id: fileId }
    if record.copies
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
  
  getSpeciesBySynonym: (synonym) =>
    @__SpeciesCollection.find({ lowerCaseSynonyms: synonym.toLowerCase() }).fetch()

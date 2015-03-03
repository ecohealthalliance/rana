@collections = {}

@collections.Files = new FS.Collection "files",
  stores: [ new FS.Store.GridFS "files", {} ]

@collections.CSVFiles = new FS.Collection "csvfiles",
  stores: [
    new FS.Store.GridFS "mongo_csvfiles", {}
    new FS.Store.FileSystem "fs_csvfiles", { path: "/tmp/workspace/csvfiles/" }
  ]

@collections.Reports = new Mongo.Collection 'reports'
@collections.Reports.attachSchema @reportSchema

@collections.Studies = new Mongo.Collection 'studies'
@collections.Studies.attachSchema @studySchema

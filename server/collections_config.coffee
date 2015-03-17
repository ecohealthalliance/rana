Meteor.publish 'files', ->
  collections.Files.find()

@collections.Files.allow
  insert: (userId, doc) ->
    true
  download: (userId)->
    true

@collections.CSVFiles.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc) ->
    true
  download: (userId)->
    true

@collections.Reports.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc) ->
    true

@collections.Studies.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc) ->
    true

Meteor.publish 'files', ->
  collections.Files.find()

Meteor.publish 'pdfs', ->
  collections.PDFs.find()

@collections.PDFs.allow
  insert: (userId, doc) ->
    true
  download: (userId)->
    true

Meteor.publish 'csvfiles', ->
  collections.CSVFiles.find()

Meteor.publish 'studies', ->
  collections.Studies.find()

Meteor.publish 'reports', ->
  collections.Reports.find({
    $or : [
      {
        "createdBy.userId": @userId
      }
      {
        dataUsePermissions: "Share full record",
        consent: true
      }
    ]
  })

@collections.Reports.allow
  insert: -> true
  update: -> true
  remove: -> true


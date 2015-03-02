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


Meteor.publish 'files', ->
  collections.Files.find()

Meteor.publish 'csvfiles', ->
  collections.CSVFiles.find()

Meteor.publish 'reports', ->
  collections.Reports.find()

Meteor.publish 'studies', ->
  collections.Reports.find()

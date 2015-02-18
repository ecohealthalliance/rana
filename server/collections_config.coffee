@collections.Files.allow
  insert: (userId, doc) ->
    true
  download: (userId)->
    true

Meteor.publish 'files', ->
  collections.Files.find()

Meteor.publish 'reports', ->
  collections.Reports.find()

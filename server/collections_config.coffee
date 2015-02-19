Meteor.publish 'files', ->
  collections.Files.find()

@collections.Files.allow
  insert: (userId, doc) ->
    true
  download: (userId)->
    true

Meteor.publish 'reports', ->
  collections.Reports.find()

@collections.Reports.allow
  insert: -> true
  update: -> true
  remove: -> true

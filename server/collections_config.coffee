@collections.Images.allow
  insert: (userId, doc) ->
    true
  download: (userId)->
    true

Meteor.publish 'images', ->
  collections.Images.find()

Meteor.publish 'reports', ->
  collections.Reports.find()
  

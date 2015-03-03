Meteor.publish 'files', ->
  collections.Files.find()

@collections.Files.allow
  insert: (userId, doc) ->
    true
  download: (userId)->
    true

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
